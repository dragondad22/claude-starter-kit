# T9 — Missing: git/PR/branch/commit conventions standard

**Category:** Gap — biggest content gap · **Status:** **Decided (2026-07-08)**

The kit *implies* conventions everywhere (`chore/release-X.Y.Z` branches, `chore(release):` prefixes, `Closes #N`) but never states them. For a kit about process consistency, source-control workflow is the most-touched undocumented process.

**Proposed:**
- **T9.1** — a short `GIT_WORKFLOW` standard (or CLAUDE.md section): branch naming, commit message format, PR description requirements, linking issues, who merges, default-branch protection assumptions.

**Open questions:**
- **T9.2** — full standard file vs. CLAUDE.md section (loads-light principle)?
- **T9.3** — adopt Conventional Commits formally or just a house style?

*(2026-07-08, from T3 discussion: Chris — PR conventions are a **core** standard in the additive-scaffolding model, present in every project from day one, not trigger-scaffolded.)*

**Additional sub-decisions surfaced 2026-07-08:**
- **T9.4** — AI attribution trailers: decide whether AI-authored commits carry an attribution trailer (e.g. `Co-Authored-By: Claude …`) as policy, given the mostly-AI-authored workflow.
- **T9.5** — Merge strategy (squash vs. merge-commit vs. rebase): interacts with T9.3 — under squash-merge, the PR title becomes the commit that survives on main, so commit-format rules apply chiefly to PR titles.

**Discussion notes:**
- 2026-07-08 (Chris): T9.1 agreed. T9.2/T9.3 options requested — see explanation in conversation; summary: T9.2 options = (a) full standard file, (b) CLAUDE.md section, (c) hybrid (rules in CLAUDE.md, depth in a standard); T9.3 options = (a) Conventional Commits formally, (b) house style. Recommendation on record: (c) for T9.2; lightweight-formal CC for T9.3 (types required, scope optional, explicitly NOT driving versioning/changelog — those stay changelog-first per the versioning standard).

**Decision (2026-07-08, all confirmed by Chris):**
- **T9.1** — Core git-workflow standard: branch naming, commit format, PR requirements, issue linking, merge policy. Present in every project (core, per T3).
- **T9.2 = (c) hybrid** — 6–8 terse enforcement rules in CLAUDE.md (branch format, commit format, never commit to main, every PR links its issue, PR-title convention); depth/why/examples in `ai/STANDARDS/GIT_WORKFLOW_STANDARD.md`.
- **T9.3 = lightweight-formal Conventional Commits** — type required, scope optional, `BREAKING` honored; standard explicitly states commit types do NOT drive versioning/changelog (changelog-first model unchanged).
- **T9.4 = no AI attribution trailers** — keep commit messages clean. Note for implementation: Claude Code appends `Co-Authored-By` by default, so the standard/CLAUDE.md must explicitly instruct against it or the tool default wins.
- **T9.5 = squash-merge** — PR title is the surviving commit and must follow CC format; intra-PR commit messages relaxed.
