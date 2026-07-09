# {{PROJECT_NAME}} Agent Setup

The living orientation doc for working in this repo with Claude Code. Keep it current.

## Overview

Claude Code is the primary AI development tool for {{PROJECT_NAME}}. Project context is
managed through `CLAUDE.md`, checklists, slash-command skills, standards, and (optionally)
a persistent memory system.

## Project Context Files

- `CLAUDE.md` — root project context: non-negotiables, commands, standards index, anti-drift rules. Loaded every session.
- Add per-area `CLAUDE.md` files (e.g. `apps/api/CLAUDE.md`) when an area needs its own patterns.

## Checklists (completion gates)
- `ai/CHECKLISTS/coding.md` — implementation gate
- `ai/CHECKLISTS/qa.md` — QA/testing gate
- `ai/CHECKLISTS/validation.md` — security + performance gate

## Slash-Command Skills
- `/bootstrap` — one-time: fill the kit's placeholders for this project
- `/preflight` — pre-commit build + test + security + changelog check
- `/qa` — QA validation against recent changes
- `/security` — security validation
- `/compliance` — external-standards + context-driven compliance check (APIs/OpenAPI, web/WCAG, mobile stores, messaging/UGC, minors)
- `/perf` — performance smoke
- `/release` — cut a release (version bump + CHANGELOG roll)
- `/evergreen` — standards & process evergreening: 5-lens review (repetition, platform delta, standards drift, date sweep, kit delta); findings → issue, run record → `docs/evergreen-log.md` (~30-day cadence, non-interruptive)

## Standards (`ai/STANDARDS/`)
Read the relevant one before working in that area. Index lives in `CLAUDE.md` → Standards.
External standards + compliance obligations (incl. mobile-store and context-driven rules)
live in `ai/STANDARDS/EXTERNAL_STANDARDS_AND_COMPLIANCE.md`; what binds this project is
tracked in `docs/compliance/COMPLIANCE_REGISTER.md`.

## Templates (`ai/TEMPLATES/`)
Issue/task body templates + the diagnostic-bundle shape
(`DIAGNOSTIC_BUNDLE_TEMPLATE.md`). Success is silent; failures produce a bundle in
`testing-reports/` (local only — never committed; CI uploads them as run artifacts).

## Scripts (`ai/scripts/`)

> **OS note:** these `*.sh` scripts require a POSIX shell — native on macOS/Linux; on
> Windows run them via Git Bash or WSL. This is the one documented OS-specific exception;
> all other docs follow the OS-agnostic rule in `ai/STANDARDS/DOCUMENTATION_STANDARD.md`.

- `release.sh` / `check-version-sync.sh` — versioning (driven by `version-files.txt`)
- `bootstrap-labels.sh` — issue-label taxonomy manifest; applies it idempotently (`gh`)
- `security-review.sh` / `performance-smoke.sh` — **stubs**; customize for this stack
- `lib/redact.sh` — strip secrets from artifacts before persisting

## CI Quality Gates
{{CI_SYSTEM}}

The kit ships a commented PR-validation seed at
`.github/workflows/pr-validation.yml.example` (GitHub Actions — paved-road default):
test + build + lint + version-sync + SCA, with commented service-container and E2E
(Playwright) blocks and an on-failure diagnostics upload. Fill tokens, uncomment the
gates the project has, rename to `.yml` to activate. On another CI system, port the
gate list — that's the durable content. Deploy/CD is not PR validation; it arrives
with the deploy-ci module when environments are decided.

<!-- Document the actual gates here once CI exists: what runs on PR vs on merge vs on a
schedule, which gates block merge vs are advisory, and where artifacts are uploaded. -->

## One-Time Setup
1. Run `/bootstrap` to fill placeholders, or fill by hand per `bootstrap/SETUP.md`.
2. Install required CLIs the scripts use: `jq` (version scripts), `gh` (if using GitHub).
3. Install project dependencies and set up local env (`.env` from `.env.example`).
4. Configure `.claude/settings.json` permissions for this project's commands.

## When Blocked
Retry documented recovery steps, switch to an equivalent path if needed, and escalate
unresolved blockers with the exact human action required. Reusable learnings belong in
the relevant standard or a tracked issue — not in chat.
