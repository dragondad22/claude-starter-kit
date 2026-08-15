#!/usr/bin/env bash
# self-conform-smoke.sh — kit self-test: prove `--apply` cannot silently destroy
# a founding doc, and that it stays a no-op on a conformant instance (#262).
#
# The bug this pins down is #244, found again in the #242 reverse pass. A
# founding doc ships, nobody adds a Seeded row to ADAPTATIONS.md, and the next
# `self-conform.py --apply` re-derives it — replacing the project's recorded
# answers with the generic skeleton. It is silent by construction: rewriting
# files is what `--apply` is *for*, so nothing distinguishes "correctly
# re-derived a generic file" from "destroyed this project's answers". In #244 it
# was harmless only because both files were still empty; both now hold real
# content, one of them the kit's release identity.
#
# Every assertion runs against a throwaway copy of this repo, never the repo
# itself — the test writes local content into an instance file on purpose, and
# the whole point is that a correct `--apply` refuses to touch it.
#
# Kit-dev tool: does not ship. Run from the repo root:
#   bash scripts/self-conform-smoke.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK="$(mktemp -d)"
cleanup() { rm -rf "$WORK"; }
trap cleanup EXIT

REPO="$WORK/repo"
cp -R "$ROOT" "$REPO"
cd "$REPO"

# A derived core file — the kit owns its content, so a conformant instance holds
# exactly the template's text. That makes it the honest stand-in for a founding
# doc that shipped before anyone thought to classify it.
TARGET="docs/specs/README.md"
SENTINEL="SENTINEL: content this project owns and --apply must not destroy"

echo "=== self-conform smoke test (work dir: $WORK) ==="

fail() { echo "FAIL: $*"; exit 1; }

SC_OUT=""; SC_RC=0
run_sc() {                       # run_sc <mode> -> $SC_OUT, $SC_RC
  set +e
  SC_OUT="$(python3 scripts/self-conform.py "$1" 2>&1)"
  SC_RC=$?
  set -e
}

seed_in_manifest() {             # seed_in_manifest <path> — declare it seeded upstream
  SEED_PATH="$1" python3 - <<'PY'
import os, re
p = os.environ['SEED_PATH']
t = open('template/manifest.yml').read()
t = re.sub(r'^seeded:\n', 'seeded:\n  - %s\n' % p, t, count=1, flags=re.M)
open('template/manifest.yml', 'w').write(t)
PY
}

unseed_in_manifest() {           # unseed_in_manifest <path>
  SEED_PATH="$1" python3 - <<'PY'
import os
p = os.environ['SEED_PATH']
lines = [l for l in open('template/manifest.yml') if l.rstrip('\n') != '  - %s' % p]
open('template/manifest.yml', 'w').writelines(lines)
PY
}

declare_seeded_row() {           # declare_seeded_row <path> — classify it here
  SEED_PATH="$1" python3 - <<'PY'
import os
p = os.environ['SEED_PATH']
lines = open('ADAPTATIONS.md').read().splitlines(True)
out, in_seeded, done = [], False, False
for line in lines:
    out.append(line)
    if line.startswith('## '):
        in_seeded = 'seeded' in line.lower()
    elif in_seeded and not done and line.startswith('|---'):
        out.append('| `%s` | Regression fixture for the #262 classification check. |\n' % p)
        done = True
assert done, 'no Seeded table found in ADAPTATIONS.md'
open('ADAPTATIONS.md', 'w').writelines(out)
PY
}

# --- 1. A conformant instance is left exactly as it was. -----------------------
# The guard must not cost `--apply` its idempotence: an already-conformant repo
# has to come out byte-identical, or every run churns the tree and `--check`
# fails on the default branch forever.
BEFORE="$(git status --porcelain)"
run_sc --apply
[ "$SC_RC" -eq 0 ] || fail "--apply exited $SC_RC on a conformant instance:\n$SC_OUT"
[ "$(git status --porcelain)" = "$BEFORE" ] \
  || fail "--apply modified a conformant instance; it must be a no-op"
echo "  conformant instance: --apply is a no-op"

# --- 2. The #244 shape: an unclassified seeded file with local content. --------
seed_in_manifest "$TARGET"
printf '%s\n' "$SENTINEL" > "$TARGET"

# Match the classification message specifically, not merely a non-zero exit:
# `--check` already fails here the old way, by reporting the file as drift. That
# signal is real but useless against this bug, because the documented sequence
# is `--upgrade && --apply` and nobody runs `--check` in between. Asserting on
# the exit code alone would pass with the guard ripped out.
run_sc --check
[ "$SC_RC" -ne 0 ] || fail "--check passed with an unclassified seeded file"
case "$SC_OUT" in
  *"$TARGET: shipped as a SEEDED file but classified nowhere"*) ;;
  *) fail "--check failed, but as generic drift — not as an unclassified seeded file";;
esac
echo "  unclassified seeded file: --check fails as a classification error"

run_sc --apply
[ "$SC_RC" -ne 0 ] || fail "--apply proceeded with an unclassified seeded file"
grep -q "$SENTINEL" "$TARGET" \
  || fail "--apply OVERWROTE an unclassified founding doc — this is the #244 bug"
case "$SC_OUT" in *'## Seeded'*) ;; *) fail "--apply did not say which row is missing";; esac
echo "  unclassified seeded file: --apply refuses, content survives, row named"

# --- 3. Classifying it lets the run proceed, and still never rewrites it. ------
declare_seeded_row "$TARGET"
run_sc --apply
[ "$SC_RC" -eq 0 ] || fail "--apply still refused after the row was added:\n$SC_OUT"
grep -q "$SENTINEL" "$TARGET" \
  || fail "a declared seeded file was rewritten; seeded means existence-checked only"
echo "  classified seeded file: --apply proceeds and leaves the content alone"

# --- 4. A row the product no longer backs is drift, not protection. -----------
# A Seeded row naming something the manifest does not seed protects nothing
# while reading as though it does — the same silence, one level up.
unseed_in_manifest "$TARGET"
run_sc --check
[ "$SC_RC" -ne 0 ] || fail "--check passed with a Seeded row the manifest does not back"
case "$SC_OUT" in
  *"$TARGET: listed under \"## Seeded\" but template/manifest.yml does not seed it"*) ;;
  *) fail "--check failed, but not as a stale-row error";;
esac
echo "  stale Seeded row: --check fails and names it"

echo "OK: self-conform smoke test passed."
