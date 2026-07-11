# T18 — Kit downstream upgrade path (template-drift problem)

**Category:** Gap (created by open-sourcing + port-back decisions) · **Status:** **Decided (2026-07-09)** · **Related:** T2 (open-source), T8 (evergreen), README port-back note

**Gap:** upstream flow exists (evergreen port-backs → kit issues) but nothing flows back down — a project scaffolded from kit v0.3 never learns about v0.5. Multiplies across adopters once open-sourced.

**Decision:** projects record the kit version they were scaffolded from (`KIT_VERSION` marker written at inception, listing scaffolded modules + versions); the kit maintains its CHANGELOG per its own versioning standard; `/evergreen` gains a **fifth lens — kit delta**: "newer kit version exists → diff the modules this project uses, propose relevant updates" (findings follow the normal T8.6 issue path with Adopt/Sandbox/Aware/Rejected verdicts). Loop closed: improvements flow up via port-back, down via evergreen.
