# T3 — Size/scope tiering mechanism (the structural gap)

**Category:** Structural — core to the kit's stated goal · **Status:** **Decided (2026-07-08)** — revised direction T3.7–T3.11 confirmed by Chris; T3.1/T3.3/T3.5 superseded as noted

The kit's goal is consistency *adapted to project size/scope*, but its only adaptation levers today are: prune DB standard, prune UI standard, one aside that reports are "optional." Everything else (triage SLAs, four reviewer roles, compliance register, formal UAT evidence) is presented at full mature-SaaS weight for every project. Realistic failure mode: small projects feel the drag and quietly abandon *all* of it — killing the consistency goal.

**Proposed shape (from review — content already exists, this is a declaration layer):**
- **T3.1** — One new interview question: "What scale? (solo/experiment · small team/production · multi-team/regulated)".
- **T3.2** — Tier definitions in README + bootstrap:
  - **Core** (every project): CLAUDE.md, coding checklist, testing standard, versioning/changelog, decision recording.
  - **Standard** (production software): + security review, documentation standard, logging, compliance register.
  - **Full** (teams/regulated): + UAT process, formal report templates, triage SLA, perf smoke.
- **T3.3** — `/bootstrap` prunes (or marks dormant) tiers above the chosen one, same as it prunes DB/UI today.

**Open questions to settle:**
- **T3.4** — exact tier boundaries (e.g. does compliance belong in Standard or Core-when-triggered?).
- **T3.5** — prune vs. mark-dormant (deleting loses the upgrade path; keeping unused files is the fat we're trimming).
- **T3.6** — can a project move up a tier later, and how?

**Decisions here constrain T5, T6, T7, T8.**

**REVISED DIRECTION (Chris, 2026-07-08) — additive scaffolding, not pruning:**
- **T3.7** — Invert the model: the kit installs a **core** set of tools/folders/templates, and everything else is a **module** scaffolded in when interview answers (or later triggers) call for it. Supersedes T3.3 (prune) and moots T3.5 (prune-vs-dormant). Rationale: pruning demands knowing what to delete on day one — the moment of least knowledge; additive matches how projects actually grow.
- **T3.8** — Supersedes T3.1: size/scope is not one question — it *emerges* from the inception interview (see T15). Interview answers produce a scaffold plan, not a tier label.
- **T3.9** — Progressive scaffolding (extends T3.6): defined **triggers** during the project's life add modules when a need appears or a threshold is met. Draft trigger table:
  | Trigger observed | Module offered |
  |---|---|
  | first schema/migration file | DB standard + schema checklist items |
  | first UI code | UI standard + UI/accessibility checklist items + aesthetics-level question |
  | first public/consumed API | OpenAPI obligation + compliance rows |
  | first formal QA/UAT need (e.g. external stakeholder acceptance) | report templates + testing-reports/ |
  | first deploy target | CI module, runbooks |
  Triggers are AI-detected at session start / preflight and **offered, never silently applied** (consistent with the compliance-trigger pattern).
  *(2026-07-08, Chris: PR conventions and triage are **core**, not trigger-scaffolded — removed from the table. Triage **SLA** specifics deferred to T6. Remaining rows agreed in principle; details expected to clarify as other topics settle.)*
- **T3.10** — Module storage: modules ship *inside* the kit copy (e.g. `bootstrap/modules/`) so progressive scaffolding works offline and stays version-consistent; scaffolding copies them into place. (Alternative — fetch from upstream kit repo at trigger time — rejected pending discussion: network dependency, upstream drift.)
- **T3.11** — T3.4 resolution direction: split compliance into a **universal baseline** every project carries (secrets handling, dependency hygiene, license, personal-data basics when any user data exists) and **conditional** rows driven by the existing trigger map. The register gets a pre-seeded Baseline section.

**Discussion notes:**
- 2026-07-08 (Chris): prefers core-plus-scaffolding over pruning (T3.3→T3.7); tier question replaced by interview-driven scaffold plan (T3.1→T3.8); progressive triggers as the project grows (T3.6→T3.9); compliance is part-universal, part-conditional (T3.4→T3.11). Inception interview split out as T15.

**Decision:**
