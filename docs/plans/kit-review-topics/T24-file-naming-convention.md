# T24 — Markdown file-naming convention: reference vs working docs

**Category:** Convention (codifies existing practice) · **Status:** **Decided (2026-07-09)** · **Related:** T11 (rationale lives once), T22 (grep-friendliness) · **Issue:** #75

**Gap:** the shipped tree follows a consistent implicit pattern — `UPPER_SNAKE_CASE.md` for reference docs, lowercase for working docs — but no standard states it, and one file violates it (`docs/decision_log.md` snake_case vs `docs/evergreen-log.md` kebab-case).

**Decision (Chris, 2026-07-09 — "standardize and update the kit to be consistent"):**
- **T24.1 — Reference docs are `UPPER_SNAKE_CASE.md`:** documents you *consult* as an authority — standards, templates, registers, indexes, process references (`TESTING_STANDARD.md`, `GLOSSARY.md`, `COMPLIANCE_REGISTER.md`, `QUESTION_BANK.md`).
- **T24.2 — Working docs are lowercase `kebab-case.md`:** documents you *run or append to* — rolling logs, checklists, slash commands, setup files (`decision-log.md`, `evergreen-log.md`, `agent-setup.md`, `coding.md`).
- **T24.3 — Ecosystem-fixed names keep their conventional form:** `README.md`, `CHANGELOG.md`, `CLAUDE.md`, `LICENSE` are exempt. ID-anchored artifacts (numbered ADRs `ADR-NNN-<slug>.md`) follow their ID convention — the hyphen belongs to the grep-friendly ID (T22), not the case rule. Chris (2026-07-09): the ADR reference docs themselves are *not* exempt → `ADR-INDEX.md`/`ADR-TEMPLATE.md` renamed `ADR_INDEX.md`/`ADR_TEMPLATE.md`.
- **T24.4 — Renames:** `template/core/docs/decision_log.md` → `decision-log.md`, `ADR-INDEX.md` → `ADR_INDEX.md`, `ADR-TEMPLATE.md` → `ADR_TEMPLATE.md`; manifest + all references updated in the same PR.
- The rule's single home (T11) is `DOCUMENTATION_STANDARD.md` → "File naming" section; everywhere else is a pointer at most.
