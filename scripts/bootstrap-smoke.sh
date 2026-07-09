#!/usr/bin/env bash
# bootstrap-smoke.sh — kit self-test: smoke-test the scaffold + fill flow that
# /bootstrap performs, without Claude in the loop (kit-dev tool; does not ship).
#
# Simulates a project adoption end-to-end, mechanically:
#   1. Copy test/fixtures/minimal-project to a temp dir.
#   2. Scaffold the manifest-listed core files plus the db module into it
#      (paths mirror the project root).
#   3. Fill every {{TOKEN}} with a dummy value (what /bootstrap does interactively).
#   4. Verify: no tokens remain outside bootstrap/ (the shipped verify rule),
#      and the shipped automation runs (check-version-sync.sh, release.sh
#      recommend mode, release.sh patch cut).
#
# Portable on purpose (bash 3.2, BSD sed) — CI runs this on ubuntu AND macos.
# Usage (from the repo root): bash scripts/bootstrap-smoke.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

echo "=== bootstrap smoke test (work dir: $WORK) ==="

# 1. Fixture project.
cp -R "$ROOT_DIR/test/fixtures/minimal-project/." "$WORK/"

# 2. Scaffold via the real engine: core installed, ALL modules staged, db
#    applied at inception (the engine reads the manifest, so the smoke test
#    can't drift from the allowlist — it fails loudly on a missing file).
bash "$ROOT_DIR/scripts/scaffold.sh" "$WORK" db > /dev/null
[ -f "$WORK/CLAUDE.md" ] || { echo "FAIL: core file missing after scaffold" >&2; exit 1; }
[ -f "$WORK/ai/STANDARDS/DATABASE_SCHEMA_STANDARD.md" ] \
  || { echo "FAIL: db module not applied at inception" >&2; exit 1; }
[ -f "$WORK/bootstrap/modules/manifest.yml" ] \
  || { echo "FAIL: manifest not staged" >&2; exit 1; }
[ -f "$WORK/bootstrap/modules/ui/ai/STANDARDS/UI_STANDARD.md" ] \
  || { echo "FAIL: ui payload not staged" >&2; exit 1; }
grep -q '^kit_version: ' "$WORK/bootstrap/KIT_VERSION" \
  && grep -qE '^  db: ' "$WORK/bootstrap/KIT_VERSION" \
  || { echo "FAIL: KIT_VERSION marker wrong" >&2; exit 1; }
echo "  scaffold engine: core installed, modules staged, db applied, KIT_VERSION written"

# 2b. Progressive scaffolding: a trigger fires later -> install a staged module
#     in-project with the shipped engine.
( cd "$WORK" && bash ai/scripts/scaffold-module.sh list > /dev/null )
( cd "$WORK" && bash ai/scripts/scaffold-module.sh ui > /dev/null )
[ -f "$WORK/ai/STANDARDS/UI_STANDARD.md" ] \
  || { echo "FAIL: progressive ui install did not land" >&2; exit 1; }
grep -qE '^  ui: ' "$WORK/bootstrap/KIT_VERSION" \
  || { echo "FAIL: progressive install not recorded in KIT_VERSION" >&2; exit 1; }
echo "  progressive install: ui module landed + recorded in KIT_VERSION"

# 3. Fill every {{TOKEN}} with a dummy value (skip bootstrap/ — it documents the tokens).
TOKENS="$(grep -rhoE '\{\{[A-Z_]+\}\}' "$WORK" \
  --include='*.md' --include='*.sh' --include='*.json' --include='*.txt' \
  | grep -vE '\{\{(TOKEN|TOKENS|PLACEHOLDER|DOUBLE_BRACE)\}\}' | sort -u || true)"
count=0
find "$WORK" -type f \( -name '*.md' -o -name '*.sh' -o -name '*.json' -o -name '*.txt' \) \
  ! -path "$WORK/bootstrap/*" | while IFS= read -r file; do
  for tok in $TOKENS; do
    name="$(printf '%s' "$tok" | tr -d '{}')"
    # sed -i.bak + rm: portable in-place edit (BSD sed requires a suffix arg).
    sed -i.bak "s|{{${name}}}|X-${name}|g" "$file" && rm -f "$file.bak"
  done
done
echo "  filled $(printf '%s\n' "$TOKENS" | grep -c . ) distinct tokens"

# Seed version state the way /bootstrap does.
printf 'VERSION\n' > "$WORK/ai/scripts/version-files.txt"
printf '0.1.0\n' > "$WORK/VERSION"
cat > "$WORK/CHANGELOG.md" <<'EOF'
# Changelog

## [Unreleased]

### Added
- bootstrapped project
EOF

# 4a. Shipped verify rule: no tokens remain outside bootstrap/.
LEFT="$(grep -rnoE '\{\{[A-Z_]+\}\}' "$WORK" \
  --include='*.md' --include='*.sh' --include='*.json' --include='*.txt' \
  | grep -v "$WORK/bootstrap/" \
  | grep -vE '\{\{(TOKEN|TOKENS|PLACEHOLDER|DOUBLE_BRACE)\}\}' || true)"
if [ -n "$LEFT" ]; then
  echo "FAIL: unfilled tokens remain after fill:" >&2
  printf '%s\n' "$LEFT" >&2
  exit 1
fi
echo "  verify: no unfilled tokens outside bootstrap/"

# 4b. Shipped automation runs in the scaffolded project.
( cd "$WORK" && bash ai/scripts/check-version-sync.sh >/dev/null )
echo "  check-version-sync.sh: OK"
( cd "$WORK" && bash ai/scripts/release.sh >/dev/null )
echo "  release.sh (recommend mode): OK"
( cd "$WORK" && bash ai/scripts/release.sh minor --date 2026-01-01 >/dev/null \
    && grep -q '^0\.2\.0$' VERSION \
    && grep -q '^## \[0\.2\.0\] - 2026-01-01$' CHANGELOG.md )
echo "  release.sh minor cut: OK (0.1.0 -> 0.2.0, changelog rolled)"

echo "OK: bootstrap smoke test passed."
