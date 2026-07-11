# T30 — Shipped kit-docs area: workflow guide with flowchart + kit reference, keep-current rule

**Category:** Gap (shipped docs) · **Status:** Not discussed · **Issue:** #93 (filed at intake; implementation blocked on this topic) · **Related:** T3 (size/scope tiering — the guide's right-sizing variants), T7 (docs-directory hygiene), T22 (context economy), T18 (kit upgrades must carry doc updates downstream), T24 (file naming), T20 (arrived via the retrospective channel)

**Origin (life-os trial):** nothing shipped explains the end-to-end kit flow. `ai/agent-setup.md` is a reference list, not a journey, and `/bootstrap`'s hand-off points back at it. Persistent "what do I do now / what's next?" for a first-time user — e.g. nowhere states that specs are per-feature (T17 artifact, created at T25 promotion), not generated at bootstrap.

**Scope (Chris, 2026-07-11):** a dedicated folder under `docs/` (candidate: `docs/kit/`) holding: (1) a **workflow guide with flowchart** — scaffold → inception interview (brief-first once T29 lands) → `/bootstrap` → external setup → roadmap intake → per-feature spec → iterative development cycle (generalized; the kit doesn't prescribe the inner loop) → release → evergreen — with a "where am I / what's next" orientation and variants by project size/scope; written for someone who has never used the kit; (2) a **kit reference**: what the kit is, every command, the directory structure, where to find things. Existing kit-related shipped docs get gathered into or pointed from this folder.

**Keep-current rule:** these docs stay current as the kit changes — kit development updates them in the same PR that changes commands, flow, or structure (binds this repo's CLAUDE.md discipline, not just downstream projects).

**To decide:** folder name/location; what moves vs. what links (`bootstrap/` path stability); flowchart format; how already-scaffolded projects receive updates (T18 delta mechanism).

**Decision:** —
