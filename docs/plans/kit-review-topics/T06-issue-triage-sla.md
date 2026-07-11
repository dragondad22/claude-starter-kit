# T6 — `ISSUE_TRIAGE_SLA.md`: fold, tier, or keep

**Category:** Trim · **Status:** **Decided (2026-07-08)** · **Depends on:** T3

Assumes a staffed quality board with SLA clocks (4-hour blocker response) and standups; references a nonexistent script; overlaps heavily with `GITHUB_ISSUES.md` label rules. For an AI-pair or solo workflow it's process theater.

**Options:** (a) fold severity/flow-label rules into `GITHUB_ISSUES.md` and delete; (b) demote to "Full" tier only; (c) keep as-is.
**Recommendation from review:** (a) or (b).

**Discussion notes:**
- 2026-07-08 (Chris): agrees with recommendation; no SLAs on current projects (no dev teams), but triage itself is core (per T3 discussion).

**Decision (2026-07-08):** Core triage rules — label discipline, severity definitions, board placement — merge into `GITHUB_ISSUES.md`; `ISSUE_TRIAGE_SLA.md` is deleted as a standalone core standard. The **SLA timing layer** (response/mitigation windows, escalation) becomes a module scaffolded by a team-formation trigger (T3.9), with the SLA numbers coming from interview answers rather than shipped constants. T1.4's dead script reference disappears with the file.
