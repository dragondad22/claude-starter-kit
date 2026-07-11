# T8 — Self-correction subsystem and `/checkpoint` vs. built-in memory

**Category:** Trim → replaced by Standards & Process Evergreening · **Status:** **Decided (2026-07-08)** (T8.3–T8.6)

- **T8.1** — `log-self-correction.sh` (117 lines) automates appending markdown Claude could write directly; modern Claude Code memory covers much of the purpose. Candidates: demote to Full tier, or replace with a one-paragraph convention ("append an entry in this format").
- **T8.2** — `/checkpoint` overlaps with Claude Code's session memory/summarization. If kept: its fallback advice to save checkpoints into `docs/runbooks/` is a category error (a session checkpoint is not a runbook) — fix regardless.

**Discussion notes:**
- 2026-07-08 (Chris): agrees both are obsolete — memory has come a long way, and actual work is tracked as well-documented GH Issues; the original purpose (getting to today's standards through trial and error) is fulfilled. **The surviving principle:** the ability to adapt and find new/better ways of doing things. Claude, tools, and features change constantly. Core principle: *periodically stop and look at what we're doing* — repeating patterns or code? new skills/Claude features to take advantage of? Working name: **Standards and Process Evergreening**.

**Decision (2026-07-08):**
- **T8.3 — Retire:** `log-self-correction.sh`, `ai/self_correction_log.md`, and `/checkpoint` are removed from the kit. Their durable functions are already covered: session continuity → Claude Code memory; work tracking → issues (T13); per-incident failure detail → diagnostic bundles (T5.4); cross-incident learning → the evergreen review below.
- **T8.4 — Replace with `/evergreen` (Standards & Process Evergreening), pending confirm of mechanism.** A periodic review with four lenses:
  1. **Repetition** — are we writing the same code/fix/workaround repeatedly? (candidate for a shared helper, a standard, or a paved-road entry)
  2. **Platform delta** — new Claude Code features, skills, or tool capabilities since last review that we should adopt?
  3. **Standards drift** — do the written standards still match actual practice? (fix the standard or fix the practice — deliberately)
  4. **Date sweep** — paved-road reviewed-dates (T16.5), compliance Verified dates, any other currency-sensitive rows.
- **T8.5 — Cadence + outputs:** session-start check, same pattern as the release trigger — "if >~30 days since last evergreen review, propose one" (also runnable on demand). Findings become tracked issues / decision-log entries / standard updates — never just conversation. **Improvements generic enough for the kit get flagged for upstream port-back** (the README's port-back note finally gets a mechanism instead of a hope). *(T8.4/T8.5 confirmed by Chris 2026-07-08.)*
- **T8.6 — Surfacing (revised 2026-07-08 with Chris's step 0; confirmed):** the review has no standalone report document and **never interrupts the session's actual work**.
  0. **Non-interruptive trigger (Chris):** when the cadence check fires at session start, do NOT propose an interactive review — the human is usually there for a specific task, possibly an emergency; an interruption gets cleared or becomes a distraction. Instead the AI runs the review **in the background / at a natural pause** and **files a GH issue** ("Evergreen review <date>", `type:task` + `evergreen` label) containing the findings and per-finding recommendations. The human reviews it from the board on their own schedule; the interactive discussion happens when the issue is *worked*, not when it's filed.
  1. **Per-finding recommendation taxonomy** (new ≠ adopt — awareness has value on its own): **Adopt** (clear win, low risk) · **Sandbox** (promising — trial in an isolated branch/worktree before any standard changes) · **Aware** (know it exists; not adopting — e.g. dependency pins/compat constraints make it break) · **Rejected** (evaluated, doesn't fit — recorded so it isn't re-litigated). Compatibility/breakage risk noted per finding.
  2. **Actionable accepted findings → issues** on the project board like all work.
  3. **Adoption/change decisions → decision log / ADR**, as any decision.
  4. **Port-back candidates → issues on the starter-kit repo** (cross-repo).
  5. **The run record → one dated entry in rolling `docs/evergreen-log.md`**: date, lenses, findings + verdicts, issue links (or "no findings"). Doubles as the cadence-check timestamp, the provenance breadcrumb, **and the seen-list**: prior Aware/Rejected verdicts are checked before surfacing — an item only re-surfaces if something material changed (new version, constraint lifted).

**T8 Decision status:** T8.3–T8.6 all confirmed 2026-07-08 — **T8 fully decided.**
