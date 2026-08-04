#!/usr/bin/env bash
# upgrade-smoke.sh — kit self-test: scaffold at an old release, upgrade to HEAD,
# assert, tear down (T36.5). Kit-dev tool; does not ship.
#
# bootstrap-smoke.sh covers the INSTALL path. Nothing covered the UPGRADE path:
# scaffold.sh writes the bootstrap/KIT_VERSION marker and, until this test, the
# marker was never read in anger. An adopter installs once and upgrades many
# times, so the untested path was the one walked most.
#
# What this asserts (mechanical, every PR) versus what the kit eats for real
# (adaptation conflicts, once per release — see scripts/self-conform.py):
#   1. a project scaffolded at an old release fills and verifies cleanly
#   2. re-running a newer scaffold over it loses no file
#   3. every core file of the NEW release is present afterwards
#   4. the upgrade never re-tokenises a file the adopter had already adapted,
#      and everything it newly delivers is fillable by the documented mechanism
# It also REPORTS how many upstream-changed files the additive upgrade left at
# their old content — a measured number, not a pass/fail, because that gap is a
# property of the additive model rather than a regression.
#
# Usage (from the repo root): bash scripts/upgrade-smoke.sh [old-tag]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OLD_TAG="${1:-}"
if [ -z "$OLD_TAG" ]; then
  # Second-newest release tag: the most recent upgrade a real adopter faces.
  OLD_TAG="$(git -C "$ROOT" tag -l 'v*' --sort=-v:refname | sed -n '2p')"
fi
[ -n "$OLD_TAG" ] || { echo "ABORT: no prior release tag to upgrade from"; exit 1; }

WORK="$(mktemp -d)"
OLDKIT="$(mktemp -d)"
BEFORE_LIST="$(mktemp)"
cleanup() {
  git -C "$ROOT" worktree remove --force "$OLDKIT" >/dev/null 2>&1 || true
  rm -rf "$WORK" "$OLDKIT" "$BEFORE_LIST"
}
trap cleanup EXIT

echo "=== upgrade smoke test ($OLD_TAG -> working tree) ==="

# 1. A kit checkout at the old release, and a project scaffolded from it.
git -C "$ROOT" worktree add --detach "$OLDKIT" "$OLD_TAG" >/dev/null 2>&1
bash "$OLDKIT/scripts/scaffold.sh" "$WORK" >/dev/null
[ -f "$WORK/bootstrap/KIT_VERSION" ] || { echo "FAIL: no KIT_VERSION after install"; exit 1; }
OLD_VER="$(sed -n 's/^kit_version: //p' "$WORK/bootstrap/KIT_VERSION")"
echo "  installed at $OLD_TAG (marker records $OLD_VER)"

# Fill tokens the way /bootstrap does, so the project looks adopted.
TOKENS="$(grep -rhoE '\{\{[A-Z0-9_]+\}\}' "$WORK" \
  --include='*.md' --include='*.sh' --include='*.json' --include='*.txt' --include='*.example' \
  | grep -vE '\{\{(TOKEN|TOKENS|PLACEHOLDER|DOUBLE_BRACE)\}\}' | sort -u || true)"
find "$WORK" -type f \( -name '*.md' -o -name '*.sh' -o -name '*.json' -o -name '*.txt' -o -name '*.example' \) \
  ! -path "$WORK/bootstrap/*" | while IFS= read -r file; do
  for tok in $TOKENS; do
    name="$(printf '%s' "$tok" | tr -d '{}')"
    sed -i.bak "s|{{${name}}}|X-${name}|g" "$file" && rm -f "$file.bak"
  done
done
(cd "$WORK" && find . -type f | sort) > "$BEFORE_LIST"
BEFORE="$(wc -l < "$BEFORE_LIST" | tr -d ' ')"
echo "  filled tokens; $BEFORE file(s) in the project"

# 2. The upgrade: a newer scaffold run over the same project.
bash "$ROOT/scripts/scaffold.sh" "$WORK" >/dev/null
AFTER="$(find "$WORK" -type f | wc -l | tr -d ' ')"
[ "$AFTER" -ge "$BEFORE" ] || { echo "FAIL: upgrade lost files ($BEFORE -> $AFTER)"; exit 1; }
echo "  upgraded: $BEFORE -> $AFTER file(s), none lost"

# 3. Every core file of the NEW release must now exist.
missing=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ -f "$WORK/$f" ] || { echo "  MISSING after upgrade: $f"; missing=$((missing + 1)); }
done < <(awk '/^core:/{c=1;next} /^modules:/{c=0} c&&/^ *- /{sub(/^ *- /,"");print}' "$ROOT/template/manifest.yml")
[ "$missing" -eq 0 ] || { echo "FAIL: $missing core file(s) absent after upgrade"; exit 1; }
echo "  every core file of the new release is present"

# 4. Run the project's OWN verify, exactly as bootstrap.md documents it, so this
# test exercises the shipped mechanism (meta-literals and bootstrap/** are
# excluded by VERIFY_IGNORE, not by a second hand-maintained list here).
#
# Then split the hits by whether the file existed before the upgrade, because
# the two cases mean opposite things (#234):
#
#   pre-existing file tokenised again -> FAIL. The upgrade clobbered a file the
#     adopter had already adapted. Silent, destructive, and the regression this
#     assertion exists to catch.
#   newly delivered file carrying tokens -> EXPECTED. Every shipped standard is
#     generic by design and arrives holding {{PROJECT_NAME}} and friends; filling
#     it is /bootstrap's retrofit job. Failing on this would mean the kit could
#     never ship a new standard again — which is exactly what it meant until #234.
#
# The new arrivals are still proven *fillable*: they get the same fill pass the
# adopted project got, and the verify must then come back clean.
verify_hits() {
  (cd "$WORK" && grep -rn '{{' . \
    --include='*.md' --include='*.sh' --include='*.json' --include='*.txt' --include='*.example' 2>/dev/null \
    | grep -vE -f <(grep -vE '^#|^$' bootstrap/VERIFY_IGNORE) || true)
}

LEFT="$(verify_hits)"
readapted=""
arrived=""
while IFS= read -r hit; do
  [ -n "$hit" ] || continue
  f="${hit%%:*}"
  if grep -qxF "$f" "$BEFORE_LIST"; then
    readapted="$readapted$hit"$'\n'
  else
    arrived="$arrived$hit"$'\n'
  fi
done <<EOF
$LEFT
EOF

if [ -n "$readapted" ]; then
  echo "FAIL: the upgrade re-tokenised file(s) the project had already adapted:"
  printf '%s' "$readapted" | sed 's|^|    |'
  exit 1
fi

if [ -n "$arrived" ]; then
  NEW_FILES="$(printf '%s' "$arrived" | cut -d: -f1 | sort -u)"
  echo "  $(printf '%s\n' "$NEW_FILES" | wc -l | tr -d ' ') new file(s) arrived generic (expected — /bootstrap fills them):"
  printf '%s\n' "$NEW_FILES" | sed 's|^|    |'
  # Prove they are fillable by the documented mechanism, not merely tolerated.
  printf '%s\n' "$NEW_FILES" | while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    for tok in $(grep -ohE '\{\{[A-Z0-9_]+\}\}' "$WORK/$rel" | sort -u); do
      name="$(printf '%s' "$tok" | tr -d '{}')"
      sed -i.bak "s|{{${name}}}|X-${name}|g" "$WORK/$rel" && rm -f "$WORK/$rel.bak"
    done
  done
  STILL="$(verify_hits)"
  if [ -n "$STILL" ]; then
    echo "FAIL: newly delivered file(s) still carry tokens after a fill pass:"
    printf '%s\n' "$STILL" | sed 's|^|    |'
    exit 1
  fi
fi
echo "  project verify clean (nothing re-tokenised; new arrivals fill cleanly)"

# 5. Measured, not asserted: what the additive model does NOT carry over.
stale=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ -f "$ROOT/template/core/$f" ] || continue
  if ! git -C "$ROOT" diff --quiet "$OLD_TAG" -- "template/core/$f" 2>/dev/null; then
    stale=$((stale + 1))
  fi
done < <(awk '/^core:/{c=1;next} /^modules:/{c=0} c&&/^ *- /{sub(/^ *- /,"");print}' "$ROOT/template/manifest.yml")
echo ""
echo "  NOTE: $stale core file(s) changed upstream since $OLD_TAG and still hold their"
echo "        old content — scaffold is additive and never overwrites. Carrying those"
echo "        forward is the /evergreen kit-delta lens's job, not the scaffold's."

echo ""
echo "OK: upgrade smoke test passed."
