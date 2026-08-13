# T18 — Kit downstream upgrade path (template-drift problem)

**Category:** Gap (created by open-sourcing + port-back decisions) · **Status:** **Decided (2026-07-09)** — **amended 2026-08-13 by [T32](T32-kit-runtime-evolution.md) (T32.12)** · **Related:** T2 (open-source), T8 (evergreen), README port-back note, T32 (delivery substrate)

> **Amendment (2026-08-13, T32.12).** The kit-delta lens below is judgment where the
> mechanical part can be deterministic. T32 gives it a floor: `csk` performs a **three-way
> merge** (base = the version scaffolded from, theirs = local edits, ours = the new
> release), and only genuine prose conflicts go to the model — resolving those *is*
> judgment. Two consequences: the **staged `bootstrap/modules/` payloads stay** (they are
> the merge base, and they are what keeps upgrade working offline), and the evergreen
> kit-delta lens survives as the **resolution layer**, not the mechanism.

**Gap:** upstream flow exists (evergreen port-backs → kit issues) but nothing flows back down — a project scaffolded from kit v0.3 never learns about v0.5. Multiplies across adopters once open-sourced.

**Decision:** projects record the kit version they were scaffolded from (`KIT_VERSION` marker written at inception, listing scaffolded modules + versions); the kit maintains its CHANGELOG per its own versioning standard; `/evergreen` gains a **fifth lens — kit delta**: "newer kit version exists → diff the modules this project uses, propose relevant updates" (findings follow the normal T8.6 issue path with Adopt/Sandbox/Aware/Rejected verdicts). Loop closed: improvements flow up via port-back, down via evergreen.
