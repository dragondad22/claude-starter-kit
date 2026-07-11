# T13 — Work-item / issue process: make GitHub Issues work as both AI memory and human tracking

**Category:** Process improvement (new topic from T1.1 discussion) · **Status:** **Decided (2026-07-08)** · **Related:** T1.1, T6, T12.3

**History:** Implementation plans (`IMP-NNN`) began as AI-generated markdown files once a project was well understood/scoped, then moved into GitHub Issues for tracking and visibility. The triage → generate issue → work issue loop works well; the issue body acts as durable AI memory for a specific piece of work.

**Pain points (Chris, 2026-07-08):**
- **T13.1 — Label standardization** is manual and drifts (kit ships two separate `gh label create` blocks that must be run by hand).
- **T13.2 — Everything is a GitHub Issue** — tasks, bugs, future ideas all in one list; hard to separate current work from future work, and issues from bugs.
- **T13.3 — Epics/features have no clear representation**, even with milestones.
- **T13.4 — Issue language is written for the AI**: lengthy, technically heavy, not readable by humans — but that detail is exactly what makes the issue function as AI memory. Need both audiences served without losing either.

**Proposals on the table (see discussion notes):**
- **T13.5** — Two-layer issue body: short human summary up top; full AI implementation brief in a collapsed `<details>` section. One source of truth, two audiences.
- **T13.6** — Kind separation via GitHub **issue types** (Bug/Task/Feature/Epic) where available (org repos), falling back to `type:*` labels on personal repos; milestones reserved for releases only (aligns with versioning standard).
- **T13.7** — Epics = parent issues using GitHub **sub-issues**; features roll up under them.
- **T13.8** — Current-vs-future via a GitHub **Projects v2** board with a Status field (Backlog / Next / In progress / Done); the AI reads the board, not the raw issue list.
- **T13.9** — Single label manifest file in the kit (e.g. `ai/labels.yml` or a script) applied idempotently at bootstrap — one source of truth for the whole taxonomy, replacing the two drifting `gh label create` blocks.

**Discussion notes:**
- 2026-07-08: Background captured; proposals T13.5–T13.9 drafted. Open: org vs. personal repos (issue-types availability), willingness to make Projects v2 part of the standard setup, how short the human layer must be.
- 2026-07-08 (Chris): **Labels over native issue types** — issue types are org-only; standardization across all repos (incl. personal) wins. **Projects: yes**, with the rule *"All repos need a project and that project needs to be kept up to date."* (Clarified: Projects v2 = GitHub's current Projects product; one project per repo, Backlog is a Status value/view, not a second project.) **Two-layer body: approved** — must not lose any of the AI-memory function the current format provides.

**Decision:** *(per sub-item; T13 overall = Decided when all sub-items land)*
- **T13.6 — DECIDED:** kind separation via `type:*` labels (`type:epic`, `type:feature`, `type:task`, `type:bug`) on every repo — no native issue types. Replaces the bare `task` / `bug` labels in the current standards.
- **T13.8 — DECIDED:** every repo gets one GitHub Project with a Status field (proposed values: Backlog / Next / In progress / Done); saved views for "Current work" (Next + In progress) and "Backlog". New rule for CLAUDE.md task-tracking section: *all repos need a project, and the project must be kept up to date* — the AI moves Status when it starts/finishes work, and treats Backlog as out-of-scope unless asked.
- **T13.5 — DECIDED:** two-layer issue body — human summary (what / why now / done-when, ~5–8 lines) on top, full AI implementation brief in a collapsed `<details>` block; task standard instructs the agent to always expand it. Per-issue Bootstrap list trimmed to task-specific files only (CLAUDE.md / agent-setup are mandated globally already).
- **T13.7 — DECIDED:** epics = parent issue (`type:epic`) with native sub-issues; features under epics; tasks under features. Milestones revert to meaning releases only. *(Verify sub-issue availability on personal repos at implementation time; fallback = task-list-of-issue-links in the epic body.)*
- **T13.9 — DECIDED:** single label manifest in the kit (one script/manifest applied idempotently by `/bootstrap`) as the sole source of the taxonomy; `GITHUB_ISSUES.md` + `TASK_ISSUE_STANDARD.md` drop their own `gh label create` blocks and point at it. Taxonomy: `type:*` (kind, exactly one) · `area:*` (project-defined) · `priority:*`/`severity:*` (by kind) · flow labels (quality findings only).
- **Board-update enforcement:** task-standard lifecycle moves Status mandatorily (start work → In progress, closing PR → Done); session-start board check is the drift-catcher (same pattern as the release-trigger check); `/preflight` NOT burdened with board checks.
