# Performance Smoke Standard

*Generic standard from the Claude starter kit — adapt to this project's stack. Replace `{{TOKENS}}`; see `bootstrap/PLACEHOLDERS.md`.*

## Purpose
Provide a lightweight performance / environment-health signal against a deployed target.
Because it measures a *deployed environment* (not the diff), it reflects environment health
rather than a per-PR code regression. Recommended cadence: run it on a **schedule**
(e.g. nightly) and on **manual dispatch** in `{{CI_SYSTEM}}` — *not* on every PR — and run
it on demand when validating a specific change.

## Measurements
Pick the signal that actually matters for this project (`{{PERF_TARGET}}`). The structure
below is an example using a health endpoint; replace with the project's real critical path:
- **Startup latency:** time from process start to first successful response.
- **p95 latency:** the p95 of repeated requests to `{{PERF_TARGET}}` during the smoke run.

## Default Thresholds
Make thresholds overridable via environment variables. Set them from `{{PERF_TARGET}}`;
example values (replace with the project's real budgets):
- `PERF_STARTUP_SLA_MS` — max acceptable startup latency (example: `20000`).
- `PERF_P95_SLA_MS` — max acceptable p95 latency (example: `400`).
- `PERF_REQUEST_COUNT` — number of samples per run (example: `40`).

## Execution
Run via the project's perf entry point:
- `ai/scripts/performance-smoke.sh <{{WORK_ITEM_PREFIX}}-NNN> <feature-slug>` (kit ships a
  stub; wire it to measure `{{PERF_TARGET}}` for this project).

## Outcome Rules
- `PASS`: all measured values are at or below their thresholds.
- `PASS-WITH-ISSUES`: slight drift, but below the blocking threshold (record it).
- `FAIL`: a threshold was breached.
- `BLOCKED`: the benchmark could not execute (record the exact blocker).

## Artifact Requirements
`PASS` is silent — exit code + one-line summary with the measured value. On
`FAIL`/`PASS-WITH-ISSUES`/`BLOCKED`, write a diagnostic bundle per
`ai/TEMPLATES/DIAGNOSTIC_BUNDLE_TEMPLATE.md` (Performance section: measured values
**and** the thresholds they were judged against), with artifacts under
`testing-reports/artifacts/<date>_<{{WORK_ITEM_PREFIX}}-NNN>_<feature>_<timestamp>/`:
- Raw sample log (per-request latencies).
- Startup log for the process under test.
