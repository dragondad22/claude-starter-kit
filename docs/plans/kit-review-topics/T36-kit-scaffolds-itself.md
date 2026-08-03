# T36 — Does the kit scaffold itself? Self-hosting beyond tracking artifacts

> **DRAFT — opened 2026-08-03 from the epic #172 post-mortem. This topic EXTENDS or
> REVISES a finalized decision (T23.3 self-hosting). Grilling started the same day;
> nothing decided yet. If decided, T23.3 is stamped-superseded in place, not rewritten.**

**Category:** Structural (extends a Decided topic) · **Status:** In discussion (2026-08-03) — grilling started · **Issue:** #181 (grill tracked) · **Related:** T23.3 (the decision this extends), T18 (`KIT_VERSION` + upgrade path — the kit would become its own first adopter), T27 (`/conform` — the drift mechanism it would dogfood), T11 (duplication with sync burden — the central objection), T2 (does not bind kit-dev), T32 (delivery substrate — sequencing question)

**Problem / Origin (Chris, 2026-08-03):** *"Why doesn't this repo adhere to the same
standards that it pushes? They work really well, I code with them every day in
ShelterSync and it feels like we're redeveloping them specifically for this repo."*

Raised after epic #172 built a kit-specific completion gate (`lint-currency.py`) and a
kit-specific PR-checklist proposal — machinery the kit already ships and did not install.

## Evidence gathered at opening

**The kit root has almost nothing of its own core installed.** Present: `CLAUDE.md`
(hand-written, not scaffolded). Absent: `ai/STANDARDS/`, `ai/CHECKLISTS/`,
`ai/agent-setup.md`, `.claude/commands/` (root `.claude/` holds only `settings.json`),
`docs/GLOSSARY.md`, `docs/decision-log.md`, `docs/architecture/decisions/`,
`docs/evergreen-log.md`, `bootstrap/KIT_VERSION`.

Consequences, all observed rather than predicted:

- **`/preflight`, `/evergreen`, `/qa`, `/conform` do not exist in this repo.** The kit
  ships a seven-lens periodic review on a ~30-day cadence to every project and never
  installed it for itself. There is no `docs/evergreen-log.md`, so the manual sweep on
  2026-08-03 was this repo's **first-ever** evergreen review — run by hand because the
  command is not here. That is the direct answer to "why wasn't the staleness caught."
- **No session-start protocol.** Shipped `agent-setup.md` checks board drift, release
  trigger and evergreen cadence every session; the kit gets none of it.
- **No completion gate.** No PR template (verified: never existed in git history), no
  checklist reference in the kit's `CLAUDE.md`. Epic #145's four PRs had nothing to
  check against, which is how the T30.2 kit-docs rule was missed four times running.

**T23.3's scope was never revisited.** It reads in full: *"the kit develops using the
process it ships — own board, typed issues, plans/ directory, releases."* Four
**tracking** artifacts. No standards, checklists, commands or gates. That enumeration
silently became the working definition of self-hosting. **No decision anywhere says the
kit should not install its own core — the question was never asked.**

**The same workaround, three times.** (a) #45 added an `RELEASE_ROOT` env-var escape
hatch so the kit could reach into `template/` for one shipped script — the issue title
says "kit self-hosting". (b) #172 built `lint-currency.py` rather than installing the
checklists. (c) The staleness sweep was run by hand rather than by `/evergreen`. Three
one-off solutions to one general problem.

## Solution space (open — the direction must come from the grill)

At least three architectures, none presumed:

- **(a) Scaffold once, maintain as an adopter.** The kit installs core into its root and
  thereafter uses `/conform` + the evergreen kit-delta lens on itself, dogfooding the
  downstream upgrade path (only trialled on CrossWise, ShelterSync, life-os so far).
- **(b) Path indirection, no copy** (symlink or config pointing at `template/core/`).
  Zero drift by construction. **Measured obstacle:** every candidate file carries
  `{{TOKENS}}` — `preflight.md` (3), `coding.md` (1), `agent-setup.md` (2),
  `TESTING_STANDARD.md` (6) — so an unfilled symlink ships a broken checklist. Viable
  only for token-free files, or with a fill step, which collapses it toward (c).
- **(c) Generated instance.** Regenerate the root instance from `template/` on demand
  (a `self-install` step) with kit-specific adaptations kept as an overlay. Drift
  impossible; more machinery.

## Open questions for the grill (seed — no presumed answers)

1. **Which architecture** — (a), (b), (c), or something else? The two-copy objection
   (T11) is the crux: one repo holding both the generic standard and a filled instance.
2. **Direction of truth.** When a standard improves, is `template/core/` edited and the
   instance conformed, or is the instance edited where the pain is felt and ported up
   (the ShelterSync port-back pattern)? Getting this wrong yields permanent drift or
   permanent double-editing.
3. **Disambiguation.** With two copies present, which does "read the testing standard"
   mean? An unstated answer is a live hazard for every future session.
4. **Scope.** All of core, or only what has a target here? The kit has no app — UI, DB,
   LOGGING, PERFORMANCE standards have nothing to govern.
5. **The kit's `CLAUDE.md`.** It is hand-written and carries kit-only non-negotiables
   (template separation, manifest allowlist). Replaced by a scaffolded instance, merged,
   or kept with a standards index added?
6. **Kit-only obligations** (manifest entry, T30.2 kit-docs, no kit-dev leak) have no
   generic home. Do they become the kit's *adaptation* of the shipped checklist — which
   is exactly what an adopting project does — and what stops that adaptation leaking
   back into the product?
7. **`KIT_VERSION` at the root is circular** — the kit scaffolded from itself. Does it
   carry one, and does a release re-conform the root instance?
8. **Does installing actually prevent the observed failures?** `/preflight` step 5 warns
   when a diff touches user-visible behaviour with no doc update. For the kit,
   "user-visible" means shipped content and "docs" means `docs/kit/` — so it only fires
   **if adapted**. Installing may be necessary without being sufficient.
9. **Sequencing vs T32.** T32 may change delivery entirely. Does this wait, or does
   being its own adopter generate exactly the evidence T32 needs?

**Decision:** — (grilling in progress)

## Discussion notes

- 2026-08-03 (Chris): raised from daily ShelterSync use — the standards "work really
  well" in a real project, and the kit rebuilding equivalents for itself is the smell.
- 2026-08-03: conceded in-session that the PR-template + kit-checklist proposal from the
  #172 post-mortem would have been straight redevelopment of `ai/CHECKLISTS/coding.md`
  and `/preflight`. `lint-currency.py` is defensible on different grounds — mechanical
  CI enforcement, which `/evergreen`'s judgment-based 30-day sweep is not — but the
  *gate* half of the problem was already solved and shipped.
