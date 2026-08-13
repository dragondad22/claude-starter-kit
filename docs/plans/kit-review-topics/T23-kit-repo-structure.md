# T23 — Kit repo structure: self-hosting kit + `template/` separation + manifest

**Category:** Structural (implementation-enabling) · **Status:** **Decided (2026-07-09)** — **amended in mechanism 2026-08-13 by [T32](T32-kit-runtime-evolution.md); not superseded** · **Related:** T3.7/T3.10 (modules), T18 (KIT_VERSION), T2 (self-test CI), T4 (kit's own README/LICENSE), T32 (delivery substrate), T36 (self-hosting apparatus)

> **Amendment (2026-08-13, T32.14/T32.16) — mechanism only; every guarantee below holds.**
> T32 asked whether a new (compiled) tooling artifact breaks physical separation or the
> allowlist. It does not, and it strengthens the second:
> - **T23.1** — `template/` remains the only shipped *content* tree. One-line amendment:
>   scaffolding reads the **binary**, which is *built from* `template/`. The tool itself
>   lives at `tool/`, is machinery rather than content, and is versioned in lockstep with
>   the kit's `VERSION` (T32.13).
> - **T23.2** — **strengthened.** The manifest becomes the **build-time embed list**, so an
>   unlisted file cannot physically ship — enforced by the compiler instead of by a lint.
> - **T23.3** — **extended.** The kit-dev Python tools (`validate-manifest.py`,
>   `lint-dead-refs.py`, `lint-currency.py`, `self-conform.py`) retire *into* the shipped
>   binary, so CI dogfoods the distributed artifact on every run rather than a smoke test.
> - **T23.4** — historical; untouched.

**Problem:** the repo root currently *is* the template — kit-dev files (this topics file, kit CI, fixtures) and shipped files live shoulder-to-shoulder with no boundary. Untenable once the kit is a real open-source project with its own development history.

**Decision (confirmed by Chris, who expected a restructure):**
- **T23.1 — Physical separation:** repo root = kit development (kit's own CLAUDE.md, README, LICENSE, VERSION, CHANGELOG, `.github/` CI, `docs/plans/`, `test/fixtures/`); **`template/` = the product** — the only tree scaffolding ever reads. Kit-dev files cannot leak into projects because they aren't in the shipped tree.
- **T23.2 — Manifest-driven allowlist:** `template/manifest.yml` maps module → files → scaffold trigger (`template/core/` + `template/modules/<name>/`). Allowlist, not blocklist: new kit-dev files are safe by default. Kit self-test CI validates the manifest (all referenced files exist; no shipped file references kit-dev paths).
- **T23.3 — Self-hosting:** the kit develops using the process it ships — own board, typed issues, plans/ directory, releases. Best test of the process and living documentation for adopters. T18's `KIT_VERSION` = the kit repo VERSION at scaffold time; evergreen kit-delta lens diffs `template/` between versions.
  - **Extended 2026-08-03 by [T36](T36-kit-scaffolds-itself.md) — not overturned.** The four tracking artifacts above remain correct, but this enumeration silently became the *whole* working definition of self-hosting for ~13 months, and nothing revisited it. Observed consequence: the kit root had none of its own core installed — no `ai/STANDARDS/`, no `ai/CHECKLISTS/`, no `.claude/commands/`, no `docs/evergreen-log.md` — so `/preflight`, `/evergreen`, `/qa` and `/conform` did not exist in this repo, and the kit's first-ever evergreen review was run by hand on 2026-08-03. T36 extends self-hosting to the full working apparatus (standards, checklists, commands, session-start protocol, gates), with `template/` as truth and the root instance derived, pinned to the last release. **No decision ever said the kit should not install its own core — the question was never asked.**
- **T23.4 — Ordering constraint:** the restructure is the **first implementation epic** — everything else builds on the new layout.
