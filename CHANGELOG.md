# Changelog

All notable changes to the Claude Starter Kit are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to Semantic Versioning.

## [Unreleased]

### Added
- Kit self-test CI on ubuntu + macOS: manifest validation, dead-cross-reference lint over shipped files, shipped-script syntax checks, and a bootstrap smoke-test that scaffolds a fixture project from the manifest, fills all placeholders, and runs the shipped automation (#6, T2/T23.2).
- Kit-dev identity: the kit repo now has its own `CLAUDE.md` (how to develop the kit), rewritten `README.md` (layout + adoption flow for the `template/` structure), and its own `.claude/settings.json`; LICENSE/VERSION/CHANGELOG confirmed as kit-repo artifacts (#4, T23.3/T4).
- `template/manifest.yml`: allowlist mapping each module to its shipped files and scaffold trigger — only manifest-listed files ever ship (#3, T23.2/T3.9).

### Fixed
- Mechanical batch (#7): `/preflight` duplicate step numbering (T1.2); task-issue standard's Completion Gate synced to the template's six items (T1.3); dead "product features list" removed from UAT precedence (T1.6); `{{E2E_COMMAND}}` added to the CLAUDE.md template Commands block (T1.8); `{{REPO_SLUG}}` token cut (T12.1); CHANGELOG template ships headers-on-demand instead of empty sections (T12.4); plans/workflows/runbooks READMEs replaced false "see ai/STANDARDS" pointers with their real charters (T7.3–T7.5).
- Shipped scripts are now genuinely portable (stock macOS bash 3.2 + BSD sed): `mapfile` replaced with while-read loops; GNU-only `sed -i` and `0,/addr/` forms replaced with `sed -i.bak` + cleanup / awk (#5, T2).

### Changed
- Restructure: all shipped content moved into `template/core/` and `template/modules/<name>/` (db, ui, reports, deploy-ci, sla); repo root is now kit-development space (#2, T23).
- Retired: `ISSUE_TRIAGE_SLA.md` as a core standard (T6), the self-correction log subsystem and `/checkpoint` (T8.3), `docs/sops/` (T7.2), the four role report templates and `new-report.sh` (T5.7 — diagnostic-bundle replacement arrives with #30).
