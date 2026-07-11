# T23 — Kit repo structure: self-hosting kit + `template/` separation + manifest

**Category:** Structural (implementation-enabling) · **Status:** **Decided (2026-07-09)** · **Related:** T3.7/T3.10 (modules), T18 (KIT_VERSION), T2 (self-test CI), T4 (kit's own README/LICENSE)

**Problem:** the repo root currently *is* the template — kit-dev files (this topics file, kit CI, fixtures) and shipped files live shoulder-to-shoulder with no boundary. Untenable once the kit is a real open-source project with its own development history.

**Decision (confirmed by Chris, who expected a restructure):**
- **T23.1 — Physical separation:** repo root = kit development (kit's own CLAUDE.md, README, LICENSE, VERSION, CHANGELOG, `.github/` CI, `docs/plans/`, `test/fixtures/`); **`template/` = the product** — the only tree scaffolding ever reads. Kit-dev files cannot leak into projects because they aren't in the shipped tree.
- **T23.2 — Manifest-driven allowlist:** `template/manifest.yml` maps module → files → scaffold trigger (`template/core/` + `template/modules/<name>/`). Allowlist, not blocklist: new kit-dev files are safe by default. Kit self-test CI validates the manifest (all referenced files exist; no shipped file references kit-dev paths).
- **T23.3 — Self-hosting:** the kit develops using the process it ships — own board, typed issues, plans/ directory, releases. Best test of the process and living documentation for adopters. T18's `KIT_VERSION` = the kit repo VERSION at scaffold time; evergreen kit-delta lens diffs `template/` between versions.
- **T23.4 — Ordering constraint:** the restructure is the **first implementation epic** — everything else builds on the new layout.
