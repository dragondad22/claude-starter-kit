# T1 — Batch of mechanical bugs (low decision content)

**Category:** Bug fixes · **Status:** **Decided (2026-07-08)** — approved as a batch; re-scope at issue-generation time (several items are mooted by other decisions: T1.1 → report tooling collapsed by T5; T1.4 → SLA file deleted by T6; T1.7 → script retired by T8). Chris: "do what you need to."

Small defects where the fix is unambiguous; grouped so they can be approved as one batch (likely one issue/PR).

- [ ] **T1.1 — `{{IMP_ID}}` never lands in report bodies.** *(→ discussion of the underlying work-item process moved to T13; fix this only in whatever form survives T13.)* `new-report.sh` substitutes `{{IMP_ID}}`, and `bootstrap/PLACEHOLDERS.md` says to leave it in templates — but all four report templates hard-code `Work Item: {{WORK_ITEM_PREFIX}}-NNN` instead. After bootstrap, scaffolded reports contain the literal `IMP-NNN`; the real ID only reaches the filename. Fix: put `{{IMP_ID}}` in the templates' Work Item field.
- [ ] **T1.2 — `preflight.md` has two step 6s** (compliance check and report results).
- [ ] **T1.3 — Completion Gate mismatch:** `TASK_ISSUE_STANDARD.md` says the gate is fixed and lists 4 items; `TASK_ISSUE_TEMPLATE.md` has 6 (adds `/compliance` + PR link). Sync the standard to the template.
- [ ] **T1.4 — Dead reference:** `ISSUE_TRIAGE_SLA.md` cites `ai/scripts/triage-sla-report.sh` — doesn't exist. (Interacts with T6 — if the SLA standard is folded, this vanishes.)
- [ ] **T1.5 — Dead reference:** `TESTING_STANDARD.md` mentions a shipped "evidence-collection script" — doesn't exist.
- [ ] **T1.6 — Dead reference:** `UAT_SOURCE_OF_TRUTH.md` precedence list includes "The product features list" — no such artifact exists or is defined anywhere.
- [ ] **T1.7 — Dead code:** `log-self-correction.sh` contains a heredoc that creates the log with a *different* header than the shipped `ai/self_correction_log.md`. The heredoc never runs (file always exists) and diverges in format.
- [ ] **T1.8 — `CLAUDE.md` Commands block omits `{{E2E_COMMAND}}`** even though the interview collects it and six files reference it.

**Discussion notes:**

**Decision:**
