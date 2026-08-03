# T5 — Fate of the formal report subsystem (4 templates + `new-report.sh` + `testing-reports/`)

**Category:** Trim / tiering · **Status:** **Decided (2026-07-08)** — reframed as failure-driven diagnostics (T5.3–T5.7)

The TESTER/UAT/SECURITY/PERF "No-Code-Touch" report machinery is inherited from a mature multi-role process. The `/qa`, `/security`, `/perf` slash commands already produce the same validation inline; formal scaffolded reports only pay off in a team/regulated process. `SETUP.md` already hints they're optional.

**Proposed:**
- **T5.1** — keep, but gate behind the T3 tier choice.
- **T5.2** — state plainly in `agent-setup.md`: *small projects — run the slash command, skip the report.*

**Discussion notes:**
- 2026-07-08 (Chris, history): reports were one of the fell-off-for-a-reason ideas. They *always* generated → hundreds of reports; initially committed (report-only commits polluting history), eventually made local-only. Original purpose was era-specific: less-reliable models → surface errors, track code reliability, correct course. Less useful now. Where they ARE useful: **CI/CD** — so AI and humans can see what went wrong and identify patterns. The goal is understanding **failure** in enough detail to fix and course-correct — *not* reporting successes or logging everything.

**REFRAME (proposed 2026-07-08): failure-driven diagnostics, not a reporting subsystem.**
- **T5.3** — Success produces no report: an exit code and a summary line. Routine/success reporting is deleted as a concept.
- **T5.4** — Failure produces a **diagnostic bundle**: what ran (commands, SHAs, env), what failed (exit codes, the failing subset), evidence (logs, artifacts, screenshots/traces where UI), suspected cause + suggested direction. Enough to fix without re-running the failure.
- **T5.5** — Homes: **CI uploads bundles as run artifacts on failure** (never committed — the report-only-commit lesson becomes a rule); local runs write to gitignored `testing-reports/` exactly as they ended up doing.
- **T5.6** — Routing: actionable findings become issues per `GITHUB_ISSUES.md` with the bundle linked; recurring failure *patterns* are T8's territory (cross-incident memory) — link pending T8 discussion.
  - **Cleared 2026-08-03.** T8 was decided the same day this was written (2026-07-08) and implemented via #31–#33 (`/evergreen`, failure bundles, session-start protocol), so the link resolved **26 days** before anyone re-read it. Found by the cleared-blockers lens (#169) on its first run — an independent catch, since nothing in that session had touched T05. Cross-incident pattern memory landed as `/evergreen`'s seen-list (`docs/evergreen-log.md`) plus the review module's JSONL run journal with `dedup_key`.
- **T5.7** — Templates: the four role report templates (TESTER/UAT/SECURITY/PERF) collapse into **one diagnostic-bundle shape** with per-gate sections; keep the good bones (evidence paths, repro, severity, self-correction row), delete success-oriented sections (executive summaries, suites-passed tables). `new-report.sh` is repurposed or retired accordingly.
- Note the symmetry: this is the same on-failure artifact philosophy the UAT standard + Playwright paved-road default already use (screenshot/trace/video **on failure**). Because PR-validation CI is core (T10.1), failure diagnostics ride along as core — no scaffold trigger needed; T5.1/T5.2 are superseded by this reframe.

**Decision:** T5.3–T5.7 confirmed by Chris 2026-07-08 — fully decided. (T5.1/T5.2 superseded by the reframe.)
