# {{PROJECT_NAME}}

{{PROJECT_TAGLINE}}.

<!--
  This is the genericized CLAUDE.md from the Claude starter kit.
  Run /bootstrap to fill the {{TOKENS}}, or edit by hand (see bootstrap/PLACEHOLDERS.md).
  Delete sections that don't apply to this project. Keep it tight — this file is
  loaded into context every session, so every line should earn its place.
-->

## Architecture

{{APP_LAYOUT}}

<!-- Example:
- `apps/api` — backend service (REST API, database)
- `apps/web` — web client
- `packages/shared` — shared types/helpers
-->

## Non-Negotiables

These are finalized architectural constraints. Do not re-litigate.

{{NON_NEGOTIABLES}}

<!-- Keep these few and real. Examples of the *kind* of thing that belongs here:
- Security/isolation invariant the whole system depends on
- Data-integrity rule (e.g. no destructive deletes of critical records; all mutations audited)
- A boundary the project has deliberately committed to
Never leave this empty — if there are truly none yet, write "None recorded yet; add as they are decided." -->

## Commands

```bash
{{TEST_COMMAND}}        # Run the test suite
{{BUILD_COMMAND}}       # Build / typecheck
{{DEV_COMMAND}}         # Start locally
{{LINT_COMMAND}}        # Lint / format check
{{MIGRATION_COMMAND}}   # Run/create DB migrations (omit if no database)

# Project automation (from repo root)
ai/scripts/new-report.sh <type> <id> <slug>     # Scaffold a quality report
bash ai/scripts/check-version-sync.sh           # Verify version files agree
bash ai/scripts/release.sh                       # Show recommended version bump
```

## Task Tracking (mandatory)

**{{ISSUE_TRACKER_KIND}} is the source of truth for all tasks, todos, and planned work** — {{ISSUE_TRACKER}}.

- Issue standard: `ai/STANDARDS/TASK_ISSUE_STANDARD.md`
- Issue template: `ai/TEMPLATES/TASK_ISSUE_TEMPLATE.md`

Rules:
- If work is identified that is not already tracked, **suggest creating a tracked item** before proceeding. Do not silently absorb untracked work into a conversation.
- Check for an existing item before creating a new one.
- Do not use local todos, memory, or chat as a substitute for a tracked item — ephemeral tracking evaporates between sessions.
- When starting work on an item, reference its ID throughout the conversation.
- When work is complete, ensure the PR/change references the item so it closes on merge.

## Decision Recording (mandatory)

- Decisions made in conversation are NOT authoritative until recorded.
- **Architectural decisions**: `docs/architecture/decisions/` (ADR format — see `ADR-INDEX.md`, `ADR-TEMPLATE.md`).
- **Product/scope decisions**: `docs/decision_log.md`.
- If implementation reveals a decision point, stop and record it.
- If a prior decision needs to change, update the existing record — don't leave stale entries.
- Ask for human approval before recording or updating decisions.

## Documentation (mandatory)

Full rules in `ai/STANDARDS/DOCUMENTATION_STANDARD.md`.

- User-facing docs have one source of truth: {{DOCS_SOURCE_OF_TRUTH}}.
- Every change that ships user-visible behavior updates the relevant docs **in the same PR**. Purely internal changes (refactor/test/infra with no user impact) are exempt.

## Source of Truth (precedence order)

1. {{DB_LAYER}} schema (if applicable)
2. ADRs: `docs/architecture/decisions/`
3. Product decision log: `docs/decision_log.md`
4. Workflow docs: `docs/workflows/`
5. UAT docs: `docs/uat/`
6. SOPs: `docs/sops/`
7. Tracked tasks: {{ISSUE_TRACKER}}

## Standards

Read the relevant standard before starting work in that area:

- Writing tests: `ai/STANDARDS/TESTING_STANDARD.md`
- Security/authz changes: `ai/STANDARDS/SECURITY_REVIEW_STANDARD.md`
- Operational logging: `ai/STANDARDS/LOGGING_STANDARD.md`
- Performance: `ai/STANDARDS/PERFORMANCE_SMOKE_STANDARD.md`
- Data/schema work: `ai/STANDARDS/DATABASE_SCHEMA_STANDARD.md` (if applicable)
- UI work: `ai/STANDARDS/UI_STANDARD.md` (if applicable)
- User documentation: `ai/STANDARDS/DOCUMENTATION_STANDARD.md`
- Versioning and CHANGELOG: `ai/STANDARDS/VERSIONING_AND_CHANGELOG_STANDARD.md`
- Bug/finding reports: `ai/STANDARDS/GITHUB_ISSUES.md`
- Task issues: `ai/STANDARDS/TASK_ISSUE_STANDARD.md`

## Checklists

Use these as completion gates:

- Coding/implementation: `ai/CHECKLISTS/coding.md`
- QA/testing: `ai/CHECKLISTS/qa.md`
- Security + performance validation: `ai/CHECKLISTS/validation.md`

## Conventions

- Never commit `.env` files or real credentials.
- Verify security/authorization boundaries with negative-path checks on every feature.
- Loading/empty/error states required for all data-driven views (if there's a UI).
- Destructive actions require explicit confirmation.
- **CHANGELOG discipline**: every PR that ships user-visible behavior adds a one-line entry under `## [Unreleased]` in `CHANGELOG.md` in the same PR. Skip only for purely internal work. Versions bump only at release time, in lockstep — use `/release` (wraps `ai/scripts/release.sh`), don't hand-edit version files. Full rules: `ai/STANDARDS/VERSIONING_AND_CHANGELOG_STANDARD.md`.

## Anti-Drift Rules

- If a conversation is getting long, re-read this file and relevant standards before continuing.
- Decisions made in chat are not authoritative until recorded in docs.
- When in doubt about a prior decision, check ADRs and the decision log — do not trust conversation memory.
- Do not assume prior context — verify by reading files.
- If work surfaces that has no tracked item, stop and suggest creating one — do not proceed on untracked work.
- Before completing any change to something shared (DB column/constraint, enum/lookup vocabulary, seed/default, shared type/helper), run the Impact Analysis (consumer sweep) gate in `ai/CHECKLISTS/coding.md` — write paths drift independently and diverge silently.
