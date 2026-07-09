# Changelog

All notable changes to the Claude Starter Kit are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to Semantic Versioning.

## [Unreleased]

### Added
- `ai/STANDARDS/INTERVIEW_STANDARD.md`: interview machinery — async question-file format (why-this-matters, options, recommendation, default, Answer/Discussion/Final), full lifecycle statuses, qualified Q-IDs (`000/Q-ARCH-03`), bidirectional provenance (`Derived:` lines + `Source:` fields on the ADR template and decision-log entries), append-only rule with supersede stamps, and the `docs/plans/<NNN>-<slug>/` directory convention where `000-inception` is instance one (#15, T15.3/T15.7/T15.9–T15.11).

## [0.3.0] - 2026-07-09

### Added
- `ai/scripts/bootstrap-labels.sh`: single label manifest for the whole issue taxonomy (`type:*` / `area:*` / `priority:*` / `severity:*` / flow labels), applied idempotently at bootstrap; both issue standards now point at it instead of shipping their own `gh label create` blocks, and bare `task`/`bug` labels are retired into `type:*` (#9, T13.9/T13.6).
- `sla` module content: `ai/STANDARDS/ISSUE_SLA_STANDARD.md` — response/mitigation windows and escalation as a timing layer over core triage, with `{{SLA_*}}` numbers coming from the team-formation interview rather than shipped constants (#13, T6).

### Changed
- Task-issue template reworked to the two-layer shape: 5–8 line human summary (what / why now / done-when) on top, full AI implementation brief in a collapsed details block; titles are clean imperatives (labels carry kind/area/priority, no more `[TASK]` prefixes); per-issue Bootstrap lists trimmed to task-specific files (#10, T13.5).
- Work-item hierarchy documented: epics are parent issues (`type:epic`) with native sub-issues, features under epics, tasks under features; milestones mean releases only — stated in both the task-issue and versioning standards (#12, T13.7).
- Project-board convention shipped: one board per repo (Status: Backlog / Next / In progress / Done, saved Current-work/Backlog views), mandatory lifecycle moves with a session-start drift check, Backlog out-of-scope unless asked; setup recipe in the task-issue standard, wired into `/bootstrap` and `SETUP.md` (#11, T13.8).
- Triage rules consolidated in `GITHUB_ISSUES.md`: label discipline, severity-based board placement, and severity-is-impact-not-urgency; the backtick ban in issue comments now states its rationale (shell command substitution mangled comments) with `--body-file` as the required alternative (#13, T6/T12.2).

## [0.2.0] - 2026-07-09

### Added
- `template/manifest.yml`: allowlist mapping each module to its shipped files and scaffold trigger — only manifest-listed files ever ship (#3, T23.2/T3.9).
- Kit-dev identity: the kit repo now has its own `CLAUDE.md` (how to develop the kit), rewritten `README.md` (layout + adoption flow for the `template/` structure), and its own `.claude/settings.json`; LICENSE/VERSION/CHANGELOG confirmed as kit-repo artifacts (#4, T23.3/T4).
- Kit self-test CI on ubuntu + macOS: manifest validation, dead-cross-reference lint over shipped files, shipped-script syntax checks, and a bootstrap smoke-test that scaffolds a fixture project from the manifest, fills all placeholders, and runs the shipped automation (#6, T2/T23.2).

### Changed
- Restructure: all shipped content moved into `template/core/` and `template/modules/<name>/` (db, ui, reports, deploy-ci, sla); repo root is now kit-development space (#2, T23).
- Retired: `ISSUE_TRIAGE_SLA.md` as a core standard (T6), the self-correction log subsystem and `/checkpoint` (T8.3), `docs/sops/` (T7.2), the four role report templates and `new-report.sh` (T5.7 — diagnostic-bundle replacement arrives with #30).

### Fixed
- Shipped scripts are now genuinely portable (stock macOS bash 3.2 + BSD sed): `mapfile` replaced with while-read loops; GNU-only `sed -i` and `0,/addr/` forms replaced with `sed -i.bak` + cleanup / awk (#5, T2).
- Mechanical batch (#7): `/preflight` duplicate step numbering (T1.2); task-issue standard's Completion Gate synced to the template's six items (T1.3); dead "product features list" removed from UAT precedence (T1.6); `{{E2E_COMMAND}}` added to the CLAUDE.md template Commands block (T1.8); `{{REPO_SLUG}}` token cut (T12.1); CHANGELOG template ships headers-on-demand instead of empty sections (T12.4); plans/workflows/runbooks READMEs replaced false "see ai/STANDARDS" pointers with their real charters (T7.3–T7.5).
