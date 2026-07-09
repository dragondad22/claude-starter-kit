# template/ — the shipped product

This tree is the **only** content that scaffolding ever reads (T23.1). Everything outside
`template/` is kit development and never lands in a project.

- `core/` — installed in every project. Paths inside mirror the project root
  (`core/CLAUDE.md` → `CLAUDE.md`, `core/ai/…` → `ai/…`).
- `modules/<name>/` — optional content, scaffolded in when an interview answer or a
  later trigger calls for it (T3.7/T3.9). Each module mirrors project-root-relative
  paths the same way.
- `manifest.yml` — the allowlist mapping each module to its files and scaffold trigger.
  Only manifest-listed files ever ship; unlisted files (this README, module READMEs)
  are kit metadata.

Decision record: `docs/plans/2026-07-08-kit-review-topics.md` (T23).
