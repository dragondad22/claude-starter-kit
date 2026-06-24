Run performance smoke validation.

1. Read `ai/STANDARDS/PERFORMANCE_SMOKE_STANDARD.md` for the signal that matters and its threshold.
2. If `ai/scripts/performance-smoke.sh` is configured, run it.
3. Measure the project's key performance signal: `{{PERF_TARGET}}`.
4. Review changed code for regressions:
   - New N+1 / repeated-query patterns
   - Unbounded queries or responses (missing pagination/limits)
   - Expensive work on a hot path
5. Compare measurements against the standard's threshold.
6. Summarize: pass/fail with measured values and any regression concerns.
