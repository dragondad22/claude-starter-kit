# T32 — Kit runtime / delivery evolution: templates-only → templates + a real tool

> **DRAFT — opened 2026-07-20 from the T31 grilling session. This topic RECONSIDERS
> finalized Non-Negotiables (T2 portable shell, T23 templates-only delivery). Per the
> anti-drift rules those are not to be re-litigated from conversation drift — this is a
> deliberate reopening by the kit owner. Needs its own grilling session; nothing decided
> yet. If decided toward a tool, T2/T23 must be stamped-superseded in place, not rewritten.**

**Category:** Structural (reconsiders Non-Negotiables) · **Status:** In discussion (2026-07-20) — opened, not yet grilled · **Issue:** — · **Related:** T2 (portable-shell constraint), T23 (self-hosting + `template/` separation + manifest), T18 (upgrade path), T31 (the forcing feature)

**Problem / Origin:** The kit currently uses **one delivery mechanism — copied POSIX shell + markdown templates — for two jobs that want different mechanisms:**
- **Judgment** (standards, playbooks, gates, the confidence/verdict/advisory model): protocol a model reads and follows. Templates + standards are the *right* fit — the kit's sweet spot.
- **Enforcement** (watchdog kill, hard budget stop, one-writer lock, run-journal integrity): code that must run reliably *outside* the model's judgment. Shell templates are a *poor* fit; bash-3.2 portability (T2) is where the mismatch draws blood.

The T31 grill surfaced this because T31 is the first feature leaning heavily on the *enforcement* category. Three independent signals point the same way, per Chris (2026-07-20):
1. A **Codex version of the kit** he's been building — "the kit" is turning out to be more than templates; tools make sense where consistent quality/deliverability matters.
2. The **downstream upgrade path** (T18) isn't as smooth as wanted; would benefit from tooling.
3. **Cross-compatibility** friction — the Codex port reached for a compiled language (Go) to overcome it. Cited as a data point, **not** a recommendation.

**Solution space (fully open — the direction must come from the grill, not from this framing):**
There is a real problem here (enforcement + install/upgrade + cross-compat don't fit copied shell). What *shape* the answer takes is deliberately left undetermined:
- **No presumed language.** Go is a valid option and the Codex precedent, but it was an *example*; the choice must **fit this kit**, not standardize a language across kits. Other languages / approaches are on the table.
- **No presumed packaging.** It need not be a single binary. It *may* start as one, but no arbitrary "everything lives in one artifact" rule — it could be a tool + templates, several small tools, a hybrid, or something else entirely.
- **No presumed identity shift.** Whether this changes the kit's "MIT shell-templates" identity is itself an output of the grill, not an assumption going in.
Whatever the shape, it must still preserve the judgment surface as templates/standards a model reads. That's the one fixed point; everything else is open.

**Open questions for the grill (seed list — neutral, no presumed answer):**
- Where does the enforcement/judgment seam actually fall? Enforcement + install/upgrade/migration are the pressure points; judgment/standards/playbooks likely stay templates — but the exact split is open.
- Does introducing *any* new (compiled or otherwise) tooling artifact break or preserve T23's physical-separation and manifest-allowlist guarantees?
- Distribution / versioning / self-hosting (T23.3) for whatever new artifacts appear; how `KIT_VERSION` (T18) and evergreen kit-delta migrate to tool-assisted upgrades.
- Language/runtime and packaging choice — driven by fit-to-this-kit, not cross-kit standardization; single-artifact vs. multiple is open.
- The MIT / open-source posture under the chosen shape.
- Migration path for already-scaffolded projects (CrossWise, ShelterSync, life-os) — additive, not a rebase.
- Which T2/T23 sub-items (if any) get superseded, and the stamped-in-place supersession record.

**Blocks:** [T31](T31-unattended-execution-mode.md) implementation (Chris chose to evolve the substrate before building the unattended-execution feature). T31's catalogued enforcement needs are concrete requirements input to this topic.

**Decision:** — (pending its own grilling session)

**Requirements input from other topics (concrete enforcement/tooling pressure points):**
- **T31** — runaway/liveness kill, one-writer-per-repo lock, budget accounting, run-journal integrity (T31.14).
- **T33** (2026-07-28) — two more, from a second feature hitting the same seam: (a) **config-merge** — `scaffold-module.sh` can only *copy* files and cannot merge into an existing `.claude/settings.json`, so a module cannot ship permissions; T33 works around it with a manual documented merge (T33.14). (b) **Hard non-prod interlock** — a mutating reviewer refuses to run against production; v1 gets a config-assertion + refuse-to-run, but a *real* interlock is enforcement that can't depend on model judgment (T33.12). Both are on the tooling side of the judgment/enforcement seam this topic is about — config-merge especially, since it's not watchdog-shaped, widens the evidence beyond T31's kill/lock primitives.
- **T35** (2026-07-28) — encoding policy is a *sibling* to this topic (execution vs data-encoding); the two share the same judgment/enforcement seam and should be reconciled, but T35 stands on its own.

**Discussion notes:**
- Chris, 2026-07-20: "the kit goes beyond just templates … tools make sense, particularly if we're trying to maintain consistent quality and deliverability." Wants to re-examine how the kit is installed/deployed to projects and how it should evolve. Prefers to make this change *before* building T31.
- Chris, 2026-07-20: the direction must come **purely from the grill**. Go is a valid option (and Codex's choice) but must not be seeded as the default — it should fit *this* kit rather than standardize a language across kits. Don't force a single-binary rule; it may start as one artifact but that's not a constraint. Removed the earlier "candidate direction" framing for seeding biased conclusions.
