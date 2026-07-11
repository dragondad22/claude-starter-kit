# T25 — Feature-request intake & roadmap: views over live issues

**Category:** Process (shipped standard) · **Status:** **Decided (2026-07-09)** · **Related:** T13 (one board per repo), T11 (rationale lives once), T22 (context economy) · **Issue:** #77

**Problem:** the kit has doctrine for planned work (task issues, board lifecycle) and quality findings, but nothing for feature *ideas* — where a request lands before it's committed work, how ideas are ordered into a roadmap, and how that roadmap is shared. The observed failure mode (Chris's prior feature-list doc): a hand-maintained catalog with Phase/status columns drifts until a precedence-order section has to be bolted on to tell readers not to trust it.

**Decision (Chris, 2026-07-09 — "I want it part of the doctrine"):**
- **T25.1 — Intake:** a feature idea or request = an issue with `type:feature`, board Status **Backlog**, lightweight body (what/who asked/why — not a full two-layer brief; that arrives at promotion). No `priority:*` required at intake. Tracker discussions (e.g. GitHub Discussions "Ideas") are an optional front door for raw/outside ideas, converted to issues when worth tracking.
- **T25.2 — The roadmap is a view over live issues, never a document:** the repo's single board (T13.8 — no second project) gains a **Horizon** single-select field (`Now / Next / Later`; blank = captured but unsorted) and a saved **Roadmap** view (open `type:feature` grouped by Horizon, manually ranked within groups). Horizon is roadmap *intent*; Status stays execution *lifecycle* — deliberately separate scales, same pattern as severity vs priority.
- **T25.3 — Visibility:** public repo → make the project public (read-only to non-collaborators, shareable URL). Private repo needing outside visibility → a *generated* roadmap file only; hand-maintained roadmap documents are prohibited.
- **T25.4 — Anti-staleness rule:** no document may carry feature status/phase/ordering columns — catalogs of ideas are prose; status lives on the board. This is the structural fix for the drift above.
- Single home (T11): `ai/STANDARDS/ROADMAP_STANDARD.md`; CLAUDE.md standards list and `TASK_ISSUE_STANDARD.md` carry pointers only. Self-hosting (T23.3): the kit's own board gets the field and view.
