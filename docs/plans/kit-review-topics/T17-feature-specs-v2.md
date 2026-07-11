# T17 — Workflow docs v2: user-journey artifacts produced by feature interviews

**Category:** Process improvement (deferred design; evolves with T15 implementation) · **Status:** Requirements captured — design deferred · **Related:** T15 (producer), T7.3 (home), UAT standard (consumer)

**Origin (Chris, 2026-07-08):** `docs/workflows/` documented user journeys derived from Q&A (examples: WF-ANIMAL-007/008). "Never worked as well as I wanted... but had useful information. I would want to rethink how all that works and what gets produced. This is something that can evolve."

**Requirements/observations captured now:**
- **T17.1** — The old docs were hand-built interview outputs before the interview process existed. Under T15, workflow docs become a **generated founding artifact of a feature interview** — derived from `Final:` fields, with T15.10 provenance links back to their questions.
- **T17.2** — Good bones worth keeping from the examples: ID convention (`WF-<DOMAIN>-NNN`), personas, preconditions, triggers, happy path, edge cases, data touchpoints, business rules, diagram, status/owner/revision.
- **T17.3** — Failure modes to design against (probe why v1 underperformed): doc rot vs. shipped behavior (no keep-current hook existed); heavyweight sections that end up empty; unclear consumption moment (who reads it, when?). Note the known consumers: UAT (precedence #3) and the AI implementing related features.
- **T17.4** — Defer detailed design to T15 implementation; revisit as the interview process takes shape.

**Additions (2026-07-08, from Chris):**
- **T17.5 — Rename: "workflows" is misleading** — the docs contain more than workflows. Proposed: **feature specs** in `docs/specs/` (ID `SPEC-<DOMAIN>-NNN`), where each spec *leads with a Journey layer*. (Alternative name "journeys" undersells the business rules/data content; "specs" with journey-first structure covers both. Name pending Chris's pick.) CLAUDE.md precedence row renamed accordingly.
- **T17.6 — Two-layer structure (the T13.5 pattern again):** top layer = **Journey** — persona, goal, plain-language steps, simple graphical flow (diagram uses user actions, never table names) — written for non-technical stakeholders to confirm assumptions; must pass a "non-technical reader" test (audience-declaration idea from T14.2). Bottom layer = **Technical spec** — preconditions, data touchpoints, business rules, edge cases — for AI/devs/UAT. One document, one source of truth, ordered by audience; the journey layer is exportable/shareable standalone.
- **T17.7 — Persona registry (gap Chris identified: personas never standardized or centralized):** `docs/PERSONAS.md` — each persona: name, who they are, goals, role/permission mapping (ties to RBAC), context/constraints (environment, device, technical comfort). Seeded by inception's audience questions (T15 spine already asks); extended by feature interviews. Specs reference personas from the registry by name — never redefine inline. Glossary role-term entries cross-link to it.
- **T17.8 — Quality mechanisms (v1 "looked good on paper, missed a lot in practice"):** (a) keep-current hook — spec updates ride the same-PR docs rule; (b) **UAT traceability** — UAT acceptance criteria trace to journey steps and edge-case rows, so a spec that misses reality fails visibly at UAT instead of silently; (c) initial quality via T15's scenario stress-testing (invent edge-case scenarios during the interview, don't just transcribe answers); (d) evergreen drift lens covers spec-vs-behavior divergence.

**Discussion notes:**
- 2026-07-08 (Chris): original goal was documenting user journeys to confirm assumptions with **non-technical stakeholders** via a simple graphical representation; v1 workflows were great technical docs but too technical to share. Quality was inconsistent; some missed a lot in practice → T17.6/T17.8. Personas gap → T17.7.
- Recurring kit-wide pattern noted (3rd occurrence): **every artifact leads with its least-technical audience** — two-layer issues (T13.5), bidirectional glossary (T14), journey-first specs (T17.6). Candidate for a stated design principle in the documentation standard at implementation time.

**Decision:** T17 decided 2026-07-08 as a requirements package (T17.1–T17.8); detailed template design still deferred to T15 implementation (T17.4). Open: final name confirmation for the artifact/directory (T17.5).
