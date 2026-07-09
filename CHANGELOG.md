# Changelog

All notable changes to the Claude Starter Kit are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to Semantic Versioning.

## [Unreleased]

### Changed
- Restructure: all shipped content moved into `template/core/` and `template/modules/<name>/` (db, ui, reports, deploy-ci, sla); repo root is now kit-development space (#2, T23).
- Retired: `ISSUE_TRIAGE_SLA.md` as a core standard (T6), the self-correction log subsystem and `/checkpoint` (T8.3), `docs/sops/` (T7.2), the four role report templates and `new-report.sh` (T5.7 — diagnostic-bundle replacement arrives with #30).
