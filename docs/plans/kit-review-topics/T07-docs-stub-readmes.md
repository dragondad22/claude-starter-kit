# T7 — `docs/plans/`, `docs/sops/`, `docs/workflows/` stub READMEs with false pointers

**Category:** Trim / fix · **Status:** **Decided (2026-07-08)** (T7.2–T7.5; workflows artifact redesign in T17)

Each README says "See ai/STANDARDS for the relevant standard" — **no standard for plans, SOPs, or workflows exists.** (`docs/uat/` and `docs/runbooks/` at least have real referents.)

**Options:** (a) give each README two real sentences — what belongs here, filename convention, when to create one; (b) delete the empty dirs and let projects add them when needed.

- **T7.1** — Note: `docs/workflows/` and `docs/sops/` are ranked in CLAUDE.md's Source-of-Truth precedence and `docs/plans/` in the UAT precedence — deleting requires touching those lists.

**Discussion notes:**
- 2026-07-08 (Chris): **SOPs** had two original uses — (a) a place to upload a *client's* SOP (their dev conventions/patterns to follow) and (b) project-defined SOPs. (b) is superseded (by standards); (a) just needs a standard home when one exists; otherwise fine deleting the dir. **Workflows** documented user journeys *based on answers to questions* — never worked as well as wanted, but contained useful information (reference examples: WF-ANIMAL-007/008 — ID, domain, status/owner, purpose, scope, personas, preconditions, triggers, happy path, edge cases, data-touchpoints table, business rules, mermaid diagram, revision history). Wants a rethink of how it works and what gets produced; can evolve → spun out as **T17**. **Plans**: fine keeping, but has been a catch-all — wants a defined purpose. **Runbooks**: fine.

**Decision (2026-07-08 — confirmed by Chris, incl. plans charter T7.4):**
- **T7.2 — `docs/sops/` deleted.** Project-defined SOPs are superseded by standards. **Client-supplied conventions** get their standard home in `ai/STANDARDS/` (e.g. `ai/STANDARDS/external/CLIENT_<name>.md`): they *function* as externally-imposed standards, get indexed in CLAUDE.md like any standard, and arrive via an inception question ("any externally-imposed conventions?") or on receipt. Precedence vs. house standards stated on arrival (client constraints usually win — contractual). SOPs row removed from CLAUDE.md source-of-truth precedence.
- **T7.3 — `docs/workflows/` concept retained, directory scaffolded on first workflow doc.** Its precedence rank stays (workflow docs outrank UAT docs when they exist). Template/product redesigned under **T17**, evolving with T15 implementation.
- **T7.4 — `docs/plans/` charter (proposed):** *structured discovery only.* Contents: interview directories (`NNN-slug/` per T15.9) and decision working documents (this topics file is the type specimen). Everything in plans/ precedes tracked work and becomes append-only history once its outputs land (T15.11). **Anti-catch-all routing rule:** a decision → decision log/ADR; work → an issue; operational how-to → runbook; user-facing → docs source of truth; term → glossary. If it isn't structured discovery or a decision working doc, it does not go in plans/.
- **T7.5 — `docs/runbooks/` stays**; README rewritten to state its real job (operational how-tos; logging standard's "where do I find errors"; deploy runbooks arrive with the CD module).
