# Claude Starter Kit (kit development)

A stack-agnostic starter kit for working on projects with Claude Code. **This repo is the
kit itself** — `template/` is the shipped product; everything else is kit-development space.

## Architecture

- `template/core/` — shipped to every project; paths mirror the project root.
- `template/modules/<name>/` — optional content (db, ui, reports, deploy-ci, sla),
  scaffolded in when a trigger fires. Same path-mirroring rule.
- `template/manifest.yml` — the allowlist: only manifest-listed files ever ship.
- Repo root — kit development: this file, README, LICENSE, VERSION, CHANGELOG,
  `docs/plans/` decision records, CI, fixtures.

## Non-Negotiables

These are finalized architectural constraints. Do not re-litigate.

- **Physical separation (T23.1):** `template/` is the only tree scaffolding reads.
  Nothing shipped references a kit-dev path; nothing kit-dev ships.
- **Manifest allowlist (T23.2):** every new shipped file must be added to
  `template/manifest.yml` in the same PR. Unlisted files never ship.
- **Portable shipped scripts (T2):** POSIX shell, bash 3.2-compatible — no GNU-only
  `sed -i` or `0,/addr/` forms, no `mapfile`. Must run on stock macOS.
- **Self-hosting (T23.3):** the kit develops using the process it ships — typed issues,
  epics via sub-issues, decision records, CHANGELOG discipline, releases.
- **Open source:** MIT; the kit repo's README/LICENSE are kit artifacts, not templates.

## Commands

```bash
python3 scripts/validate-manifest.py   # allowlist complete, files exist, no kit-dev leaks
python3 scripts/lint-dead-refs.py      # shipped docs cite only files that ship
bash scripts/bootstrap-smoke.sh        # scaffold + fill + shipped automation end-to-end

# Kit release cut — the shipped script run against the kit root (issue #45):
RELEASE_ROOT="$PWD" VERSION_FILES_LIST="$PWD/scripts/version-files.txt" \
  bash template/core/ai/scripts/release.sh <bump>
```

All three run in CI (`.github/workflows/kit-selftest.yml`) on ubuntu + macos —
run them locally before pushing changes to `template/`.

## Task Tracking (mandatory)

**GitHub Issues are the source of truth for all kit work** — https://github.com/dragondad22/claude-starter-kit/issues.

- Kinds via `type:*` labels (epic/feature/task/bug); epics use native sub-issues (T13).
- Untracked work: suggest an issue before proceeding; check for an existing one first.
- Reference the issue ID while working; the PR must reference it so it closes on merge.

## Decision Recording (mandatory)

- Decisions made in conversation are NOT authoritative until recorded.
- Kit decisions live in `docs/plans/` decision records: index
  `docs/plans/2026-07-08-kit-review-topics.md` + one file per topic under
  `docs/plans/kit-review-topics/` (`TNN-<slug>.md`; format: its `TOPIC_TEMPLATE.md`).
  Stable T-IDs, Status/Discussion/Decision per topic, superseded entries stamped,
  never rewritten; Status changes mirror to the index table.
- `docs/plans/` is structured discovery only (T7.4): interview/decision working docs.
  A decision → decision record; work → an issue; how-to → runbook; term → glossary.
- Ask for human approval before recording or updating decisions.

## Git & PRs

- Branch per issue (`feat/<issue#>-slug`); never commit to main.
- Squash-merge; the PR title survives as the commit and follows Conventional Commits
  (type required, scope optional) (T9).
- No AI attribution trailers in commit messages (T9.4).
- Every PR that changes shipped content adds a line under `## [Unreleased]` in the
  kit's `CHANGELOG.md` (root). Versions bump only at release time.

## Editing Shipped Content

- The kit follows its own shipped standards — read the relevant one in
  `template/core/ai/STANDARDS/` before editing that area.
- "Rules may repeat; rationale may not" (T11): explanations live in exactly one
  standard; other appearances are one line + a pointer.
- Context economy (T22): breadcrumbs over monoliths; never cut the vision — relocate
  detail behind a reference. The shipped `CLAUDE.md` stays within ~150 lines.
- Placeholders: shipped files carry `{{TOKENS}}` documented in
  `template/core/bootstrap/PLACEHOLDERS.md`. Keep them; the kit repo never fills them.
- OS-agnostic docs: no OS-specific instructions in shipped docs unless labeled
  (rule: `template/core/ai/STANDARDS/DOCUMENTATION_STANDARD.md`).
- Kit-docs keep-current (T30.2): a PR that changes shipped commands, the workflow,
  or the shipped directory structure updates `template/core/docs/kit/` in the same PR.

## Anti-Drift Rules

- Decisions made in chat are not authoritative until recorded in `docs/plans/`.
- When in doubt about a prior decision, grep the T-ID in the decision record —
  do not trust conversation memory.
- New shipped file → manifest entry, same PR. New kit-dev file → nothing to do
  (allowlist keeps it safe).
- If work surfaces with no tracked issue, stop and suggest creating one.
