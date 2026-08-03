# Evergreen Log

Rolling record of Standards & Process Evergreening reviews (`/evergreen`). One
dated entry per run, newest on top — append-only: entries are never rewritten,
a changed verdict gets a new entry.

This file does triple duty:

- **Cadence timestamp** — the session-start check compares the newest entry's
  date against the ~30-day cadence.
- **Seen-list** — before surfacing a finding, `/evergreen` checks prior
  **Aware**/**Rejected** verdicts here; an item re-surfaces only if something
  material changed (new version, constraint lifted).
- **Provenance breadcrumb** — why a standard/tool changed traces back to a
  dated review entry and its issue links.

Entry shape:

```markdown
## YYYY-MM-DD
- Lenses: repetition · platform delta · standards drift · date sweep · kit delta · context economy
- Review issue: #NN (or "no findings")
- Findings:
  - <finding> — **Adopt|Sandbox|Aware|Rejected** (<one-line reason / risk note>) → #NN
```

<!-- No reviews recorded yet. The first /evergreen run adds its entry below. -->

## 2026-08-03

- Lenses: repetition · platform delta · standards drift · date sweep · kit delta · context economy · cleared blockers
- Review issue: findings filed directly (epics #172 and #183) — this repo's **first** evergreen review
- Run note: performed **by hand**. `/evergreen` was not installed here at the time; that absence was
  itself the largest finding, and is what opened T36 (#181) and epic #183.
- Findings:
  - `docs/kit/` never learned about the `review` module, `/review` or `.claude/agents/` despite the keep-current rule — **Adopt** (four PRs in one epic missed it; a rule nothing enforces is not a control) → #174
  - `Last Updated` on 2 of 19 shipped standards, no rule requiring it, both existing dates stale — **Adopt** (a distributed copy has no history, so the stated date is the only currency signal a reader gets) → #173
  - No mechanical enforcement of enumerations or dates — **Adopt** (`scripts/lint-currency.py`, blocking in CI) → #175
  - `template/core/CLAUDE.md` at 151 lines against its own ~150 budget — **Adopt** (compressed to 148; relocate, never delete) → #174
  - Kit-dev enumerations stale: modules missing `review`, commands missing `/evergreen` `/conform` `/rebaseline` — **Adopt** → #176
  - T5.6 "link pending T8 discussion" resolvable for 26 days — **Adopt** (found by the new cleared-blockers lens on its first run — an independent catch) → #176
  - The kit installs none of its own core, so `/preflight`, `/evergreen`, `/qa` and `/conform` did not exist here — **Adopt** (root cause of everything above) → T36, epic #183
  - Verify grep misses digit-bearing tokens, never scans `.yml`/`.example`, and collides with GitHub Actions `${{ }}` — **Adopt** (affects every adopter; found only by dogfooding) → #190, #192
  - Downstream projects still have no equivalent to `lint-currency.py` — **Aware** (requirements input to T32; shipping a bash-3.2 linter while that decision is open would build on a substrate under reconsideration)

