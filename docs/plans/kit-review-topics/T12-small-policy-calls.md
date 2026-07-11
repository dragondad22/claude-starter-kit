# T12 — Small policy calls (quick decisions, grouped)

**Category:** Misc decisions · **Status:** **Decided (2026-07-08)** (all four)

- [ ] **T12.1 — `{{REPO_SLUG}}`:** interviewed + registered, used nowhere. Use it (CLAUDE.md / agent-setup identity block?) or cut the interview question.
- [ ] **T12.2 — "Never use backticks in issue comments"** (`GITHUB_ISSUES.md`): unexplained scar-tissue rule. State the rationale or delete — rules without reasons get ignored, then all rules do.
- [ ] **T12.3 — severity vs. priority label split** (quality issues vs. task issues): deliberate and documented, but add one cross-pointer sentence in `GITHUB_ISSUES.md` so adopters don't unify them by accident.
- [ ] **T12.4 — CHANGELOG ships with empty `### Added/Changed/Fixed/Security` headers** under `[Unreleased]` — at first release these roll into the version heading as empty sections. Cosmetic; decide whether headers appear on demand instead.

**Discussion notes:**
- 2026-07-08 (Chris): T12.1 agree (cut). **T12.2 — scar confirmed:** issue comments were constantly mangled by backticks and repeatedly had to be fixed → the rule STAYS, now with its rationale stated. T12.3 agree. T12.4 agree.

**Decision (2026-07-08):**
- **T12.1** — `{{REPO_SLUG}}` cut; repo remote detected from `git remote -v` at runtime when needed (T15 rebuilds the interview anyway).
- **T12.2** — Rule **kept**, rationale documented next to it: backticks in issue comments were repeatedly mangled (shell command-substitution in `gh`-style CLI calls is the likely mechanism) and constantly needed fixing. Implementation may add the safe alternative: pass bodies via `--body-file` rather than inline strings.
- **T12.3** — One cross-pointer sentence added to `GITHUB_ISSUES.md` explaining the severity (findings) vs. priority (planned work) split; the label manifest (T13.9) encodes it structurally.
- **T12.4** — Headers-on-demand: section headers appear when the first entry of that type lands. Changelog version of success-is-silent; `release.sh` already tolerates absent sections.
