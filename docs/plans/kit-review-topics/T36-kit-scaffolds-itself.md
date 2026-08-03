# T36 — Does the kit scaffold itself? Self-hosting beyond tracking artifacts

> **Decided 2026-08-03 (grilling session with Chris). This topic EXTENDS a finalized
> decision — T23.3's self-hosting scope, stamped in place, not rewritten.**

**Category:** Structural (extends a Decided topic) · **Status:** **Decided (2026-08-03)** — grilled · **Issue:** #181 (grill) → implementation epic **#183** (sub-issues #184–#188) · **Related:** T23.3 (the decision this extends), T18 (`KIT_VERSION` + upgrade path — the kit would become its own first adopter), T27 (`/conform` — the drift mechanism it would dogfood), T11 (duplication with sync burden — the central objection), T2 (does not bind kit-dev), T32 (delivery substrate — sequencing question)

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

**Decision (2026-08-03):**

- **T36.1 — Architecture: scaffold, commit, and check.** The kit installs its own core into
  the repo root and commits the result. Drift is not managed by discipline: a **conformance
  check** asserts each instance file equals its `template/` counterpart with tokens filled.
  Path indirection was rejected on measured grounds — every candidate file carries
  `{{TOKENS}}` (`preflight.md` 3, `coding.md` 1, `agent-setup.md` 2, `TESTING_STANDARD.md` 6),
  so a symlink ships a broken checklist. A generated-and-gitignored instance was rejected as
  new machinery while T32 is open.

- **T36.2 — `template/` is truth; the instance is derived.** The rule governs the **end state
  of a PR, not the authoring order**: fix a problem wherever you notice it, but the PR lands
  conformant. Deliberate divergence is legal only as a **declared adaptation carrying a
  one-line reason**, and the check reports the adaptation count so growth stays visible
  instead of becoming a quiet dumping ground.

- **T36.3 — Scope is decided by the shipped machinery, not by hand.** The kit is retrofitted
  as a real adopting repo (`/bootstrap` retrofit / `/conform`), answering inception honestly
  for a docs-and-scripts project with no runtime, and installs whatever that produces.
  Hand-picking a subset was rejected as the same move that produced `lint-currency.py`
  instead of installing the checklists. **Friction found in the retrofit is a finding about
  the adoption path, not a kit-specific inconvenience.**

- **T36.4 — The instance is pinned to the last *release*, and the upgrade is what gets
  eaten.** Root `KIT_VERSION` tracks the last released version; the conformance check
  compares the instance against `git show v<KIT_VERSION>:template/core/…` rather than HEAD.
  So each release makes the kit perform a **real self-upgrade**, exercising the one part of
  the upgrade path no test can meaningfully cover: **declared adaptations colliding with
  upstream changes**. Cost accepted (Chris, 2026-08-03): between releases the kit works
  against last-released standards, so an improvement does not reach the kit until it ships —
  which is exactly what an adopter feels, and creates healthy release pressure. If a fix is
  ever urgent, cutting a release is the escape hatch, and releases are cheap.

- **T36.5 — Install is *tested*, not eaten; upgrade is *eaten* and also gets a test.**
  Chris's framing (2026-08-03): *"New installs can be scaffolded, tested, and torn down
  automatically. We don't eat them, but we do test them."* Half of this was already true —
  `scripts/bootstrap-smoke.sh` does `mktemp -d` + `trap rm -rf` on ubuntu and macOS every PR.
  The gap is that **nothing has ever read the `KIT_VERSION` marker in anger**: `scaffold.sh`
  writes it, and the kit-delta lens has never run against a real repo. So the upgrade path
  gains the same scaffold-test-teardown treatment (scaffold at an old release → upgrade to
  HEAD → assert → discard), *in addition to* being eaten at each release.

- **T36.6 — Derived, not decided: disambiguation follows T23.1.** With two copies present,
  the existing frame already answers it — repo root is kit development, `template/` is the
  product. **The instance governs how work is done here; `template/` is the thing being
  built.** Reading a standard to know how to work → the instance. Changing a standard →
  `template/`, propagated in the same PR.

- **T36.7 — Kit-only obligations become declared adaptations.** Manifest entry, T30.2
  kit-docs keep-current, no-kit-dev-leak have no generic home, so they are the kit's
  *adaptation* of the shipped checklist — which is precisely what an adopting project does
  to a generic standard. They ride the T36.2 adaptation mechanism with reasons.

- **T36.8 — Installing may be necessary without being sufficient.** `/preflight` step 5 only
  fires for the kit once "user-visible" is adapted to mean shipped content and "docs" to mean
  `docs/kit/`. Adapting it is an acceptance criterion of the implementation, not an
  afterthought — an installed-but-unadapted gate is a gate that does not fire.

- **T36.9 — Proceed now; follows the T33 precedent, not T31's.** T36 builds almost nothing
  new — the scaffold, `/conform` and the checklists already ship — so T32's substrate
  decision gates none of it, and running the kit as its own adopter generates exactly the
  install/upgrade friction evidence T32 lacks. Parking a second topic behind an undecided
  T32 (T31 has waited since 2026-07-20) is how backlogs calcify.

**Known limits — recorded, not overclaimed:** the kit dogfoods **install-and-stay-conformant**
and, via T36.4, **upgrade**. It does **not** cover **port-back friction** — a real adopter
feels *"I need this changed and I cannot change it,"* which is what produces port-back issues;
the kit can always edit the product directly. Real adopters (ShelterSync, CrossWise, life-os)
remain the only evidence source for that half. An overclaimed benefit is worse than a narrow
honest one.

**Supersession:** T23.3 is **extended, not overturned** — its four tracking artifacts (board,
typed issues, `plans/`, releases) remain correct; self-hosting now also covers the working
apparatus (standards, checklists, commands, session-start protocol, gates). Stamped in place
in `T23-kit-repo-structure.md`.

## Discussion notes

- 2026-08-03 (Chris): raised from daily ShelterSync use — the standards "work really
  well" in a real project, and the kit rebuilding equivalents for itself is the smell.
- 2026-08-03: conceded in-session that the PR-template + kit-checklist proposal from the
  #172 post-mortem would have been straight redevelopment of `ai/CHECKLISTS/coding.md`
  and `/preflight`. `lint-currency.py` is defensible on different grounds — mechanical
  CI enforcement, which `/evergreen`'s judgment-based 30-day sweep is not — but the
  *gate* half of the problem was already solved and shipped.
- 2026-08-03 (grill, Q7): the AI recommended accepting that a permanently-conformant
  instance never experiences an upgrade, and recording the narrowed benefit. **Chris
  rejected both offered options** and reframed: *"the Upgrade (with the exception of the
  first implementation) should be the dog food we are eating. New installs can be
  scaffolded, tested, and torn down automatically. We don't eat them, but we do test them.
  I'm not sure the realities of that however."* Checked against the tree, the reframe held:
  install was **already** scaffold-test-teardown (`bootstrap-smoke.sh`), and upgrade was
  neither tested nor eaten. The realities cost one changed git argument in the conformance
  check. Recorded as T36.4/T36.5; the AI's Q7 recommendation is superseded by this note.
- 2026-08-03: questions Q3 (disambiguation) and Q5 (the kit's `CLAUDE.md`) were **not put to
  Chris** — both were forced by answers already given (T23.1's frame; the retrofit path's
  existing handling of a repo with its own `CLAUDE.md`, per #116). Asking a question whose
  answer is determined launders the asker's assumption into the record as a decision.
