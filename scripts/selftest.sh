#!/usr/bin/env bash
# selftest.sh — the kit's test suite, in one entry point.
#
# The kit has no application to test; its "tests" are the four self-checks that
# verify the shipped tree is valid, consistent, current, and installable. This
# wrapper exists so the project's test-command placeholder has one honest answer,
# and CI, the checklists, and a human all run the same thing.
#
# Kit-dev tool: does not ship. Run from the repo root: bash scripts/selftest.sh
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

python3 scripts/validate-manifest.py
python3 scripts/lint-dead-refs.py
python3 scripts/lint-currency.py
python3 scripts/self-conform.py --check
bash scripts/bootstrap-smoke.sh

echo "OK: kit self-test passed (manifest, dead refs, currency, self-conformance, bootstrap smoke)."
