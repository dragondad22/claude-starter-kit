# Working doc: the kit's own release identity — archetype, promise, and what 1.0 is

**Date:** 2026-08-14 · **Issue:** #242 · **Purpose:** run the release framework the kit
ships (`ai/STANDARDS/RELEASE_STANDARD.md`, ADR-001) against the kit itself, and record
what it produces — including everywhere the framework did not fit.

**Measured against this repo on 2026-08-14:** version `0.14.0`, **15 open issues**,
**0 milestones**, three named adopters (CrossWise, ShelterSync, life-os), no journey
registry, and a `docs/registers/PRODUCT_REGISTER.md` whose `AC-`/`INV-`/`NFR-` rows are
all empty skeletons.

> **Approved by Chris, 2026-08-14** — the three decisions in § 2. The promise sentences
> in § 4 were drafted here and approved with them.

Outcome recorded in `docs/releases/README.md` (archetype + releases in sequence); this
doc is the reasoning behind those rows and is cited by them.

---

## 1. Why this was owed

ADR-001 § 6 records the follow-up in one line: *"The kit's own release identity is
undecided — it is at `0.12.0` and has never been asked the question. Apply this framework
to the kit itself once shipped."* It shipped in v0.14.0. The version in that line is now
stale by two minors, which is itself the symptom.

The framework exists to stop a specific failure, stated in the standard it produced:

> The project **drifts on `0.x` indefinitely**, because nothing ever asks the 1.0 question
> and `1.0.0` is defined as a one-time judgement call nobody is routed to. To a reader,
> `0.x` says "unstable, still under development" long after it stopped being.

The kit is that reader's example: fourteen minor releases, three projects depending on it
in earnest, and a version number that tells anyone who looks not to. Shipping the cure and
not taking it is the failure class epic #172 exists to stop.

**What unblocked it.** `docs/releases/README.md` recorded the deferral honestly — *"Not
yet decided (2026-08-12) … the contract surface depends on the delivery shape, which is
#159's to decide. Tracked in #242; deferred deliberately, not unasked."* **#159 closed on
2026-08-13** with T32: the kit ships a compiled Go tool, `csk`, with templates embedded in
the binary and upgrade as a three-way merge. The stated blocker is gone.

**A second reason, beyond compliance.** The framework was derived from exactly one
product — ShelterSync, a running service with a database, a payment processor and a
privacy policy. The kit is structurally its opposite: a repository that ships documents
into other people's repositories, with no runtime, no users in the data-protection sense,
and no money. That makes it the cheapest available test of whether the framework
generalises, and **anywhere it does not fit is a port-back, not an exception** (§ 7).

**A third, concrete one.** `/readiness` step 1 says *"No named release recorded → stop and
ask for one."* The kit ships a command that hard-stops against its own repository.

---

## 2. The three decisions

Taken 2026-08-14, after the evidence in §§ 3–6 was on the table.

### 2.1 Two releases, named now

`1.0` is today's kit, stabilised. `2.0` is the csk-delivered kit. Both are named in
`docs/releases/README.md` before either is scoped.

**Why not one.** The framework's headline finding is that two candidate releases collide
in one undefined `1.0` and make the question unanswerable — *"not because it is hard, but
because it is two questions wearing one label."* The kit has exactly that collision:

- *"The kit is safe to depend on"* — a promise to people who already have it. Nearly true
  today; the gap is evidence, not capability.
- *"The kit is a product anyone can acquire"* — a promise to people who do not have it.
  A large body of work, decomposed as #246–#257.

Naming them separates a release reachable in weeks from one measured in months. Collapsing
them would have deferred `1.0` behind the whole csk programme, which is the perpetual-`0.x`
failure with a better excuse.

**The cost, stated plainly.** `1.0` names a delivery shape already slated for replacement,
so `2.0` follows sooner than a MAJOR usually does. That is survivable because T32.14 makes
the csk migration additive: *"CrossWise, ShelterSync and life-os keep working installs …
existing scripts keep functioning until each project runs an explicit `csk adopt`. Nothing
is rebased."* A fast MAJOR that costs adopters nothing is a naming event, not a migration.

### 2.2 Release-versioned only — one row, one number

MAJOR means **a committed promise lands**. Adopter-affecting changes are still declared
`**BREAKING:**` naming whose contract broke, per the standard's breaking-for-whom rule, but
**they do not force a MAJOR**.

**The problem this resolves.** The kit is a single artifact with *both* audiences the
standard separates. Project owners are users: they read the standards and run the commands.
Adopter repositories are integrators: their on-disk state depends on file paths, the
`bootstrap/KIT_VERSION` marker, the `{{TOKEN}}` registry, the `scaffold-module.sh` and
`release.sh` interfaces, and the constrained YAML subset both scaffold engines parse with
awk. The standard says *"pick one per versioned thing"* and assumes *"the two identities
move independently"* — but T32.13 puts the tool, the templates and the kit on **one number
with one CHANGELOG and one cut**. So two MAJOR triggers compete for one number, and the
standard does not say which wins.

**Why the promise wins.** Under the additive model an adopter break is *repairable, not
integration-fatal*, and that is the difference the contract archetype is built on. Three
things make it true:

- `scaffold.sh` has **no delete path and never overwrites** — `copy_into()` skips existing
  files with a warning. Nothing an adopter has adapted is destroyed by taking a release.
  `scripts/upgrade-smoke.sh` assertion 4 enforces exactly this: a pre-existing file
  re-tokenised is a FAIL, *"the upgrade clobbered a file the adopter had already adapted."*
- csk phase 3 (#248) turns upgrade into a mechanical three-way merge, which strengthens
  the same guarantee rather than replacing it.
- An integration that breaks silently at runtime is the harm SemVer's MAJOR protects
  against. Nothing here runs. The worst case is a document that is a release behind, and
  the kit-delta lens exists to surface it.

If a `**BREAKING:**` entry forced MAJOR, renames and removals would burn MAJORs fast — the
kit already shipped three breaking entries inside the MINOR `0.13.0` — and `2.0` would stop
meaning "the csk promise". Reserving MAJOR for promises keeps the number saying one thing.

**What still protects the adopter**, so this is a routing decision and not a weakening:
the `**BREAKING:**` prefix and its named audience remain mandatory; the additive model
guarantees nothing is destroyed; and the gaps this leaves are recorded as work in § 6.

**The event log gets its own number.** T32.9 makes the log *"versioned and self-describing
so an independent implementation can read it without sharing code."* That is a genuine wire
format with a genuine integrator — the Codex kit is a separate implementation, not a
front-end (T32.8) — and it is the one thing here that really does move independently. It
takes a **contract-versioned row of its own when #247 builds it**, versioned inside the log
rather than by `VERSION`. Not recorded now: recording an archetype for an artifact that does
not exist would be the same guessing this exercise exists to stop.

### 2.3 No journey backfill in this issue

The need limb wants journeys. The kit has none: `docs/uat/JOURNEY_REGISTRY.md` belongs to
the review module, whose trigger is a driveable UI, and the kit has no UI. The
`AC-`/`INV-`/`NFR-` rows in `docs/registers/PRODUCT_REGISTER.md` are empty skeletons, so
`/readiness` step 3 has nothing to assert against.

The standard permits the walk without a registry — *"its output is simply judged rather
than checked, and the backfill is what upgrades it"* — and ADR-001 § 3 already names the
backfill as real work. So: run the walk judged, **stamp the release record with the fact
that it was judged**, and file the backfill separately. An absent row and a considered
"not applicable" look identical otherwise, which is the failure the stamp prevents.

Installing the review module to obtain a journey registry was rejected: it would install a
UAT driver, a data verifier and a UX-conformance agent into a repository that has no UI to
drive, and a module installed against its own trigger is a bad dogfooding signal.

---

## 3. Archetype

| Versioned thing | Archetype | What MAJOR means here |
|---|---|---|
| The kit — `template/` payload, the process it ships, and (from T32.13) `csk` in lockstep | **release-versioned** | A committed promise lands: a new promise to a new audience |

One row, per § 2.2. The event-log format becomes a second row when #247 builds it.

**Where this leaves the `0.x` escape hatch.** `VERSIONING_AND_CHANGELOG_STANDARD.md` says
*"while a project is on `0.x` and has not yet recorded a release identity, a breaking change
is a `Changed` entry and bumps MINOR — but that state is a question waiting to be asked, not
a resting place."* Recording identity closes that hatch. It is replaced by the explicit rule
in § 2.2, not by silence.

---

## 4. The promises

### 1.0 — the kit is safe to depend on

> **A developer who has this repository can install the kit into a new or existing project,
> run that project by it from inception through release, and take a later kit release
> without losing or damaging what they have adapted.**

- **Audience:** the three named adopters — CrossWise, ShelterSync, life-os — plus anyone
  who clones the repository.
- **Parties:** the adopting developer, and the maintainer, who must be able to cut a
  release and re-derive the kit's own instance from it. The maintainer is this project's
  answer to *"a promise phrased only in the user's terms describes software"* — there is no
  commercial party, because MIT and no money means the commercial limb is empty.
- **Falsifiable:** point at ShelterSync, CrossWise or life-os and ask whether they can.

**On the deliberate weakness of the last clause.** *Take a later release without losing or
damaging what they have adapted* is what the additive model actually guarantees today, and
no more. It is not *upgrade with your edits merged* — that needs the three-way merge in
#248 and belongs to `2.0`. `upgrade-smoke.sh` measures the gap and refuses to assert on it,
*"because that gap is a property of the additive model rather than a regression."* A promise
should not claim what its own test declines to assert.

### 2.0 — the kit is a product anyone can acquire

> **Anyone can find the kit, install it without cloning anything, scaffold a project from
> the tool alone on macOS, Linux or Windows, and upgrade an existing project across releases
> with their edits merged rather than skipped.**

- **Audience:** the market.
- **Parties:** the acquiring developer, and the maintainer, who must be able to publish
  binaries for every target platform and have adopters' CI find them on PATH (T32.4).
- **Why this is a MAJOR:** it is a new promise to a new audience — the release-versioned
  trigger, exactly as written. It is also the release where the commercial limb finally has
  something in it, in the acquisition sense if not the monetary one: today there is no way
  to get the kit without cloning the repository, and *"if there is no way to sign up, there
  is no product — there is a website and an application."*

---

## 5. Membership

Recorded in the milestones, not here. This section holds the reasoning; the milestone is
the manifest, and a mirrored list drifts.

Milestones created 2026-08-14: **`1.0 — safe to depend on`** and **`2.0 — acquirable`**.
The repository had none before, which is worth noting in a project whose own standard says
*"the milestone is the manifest."*

### 5.1 Forward pass

*Would you delay the release for this?* — applied to all 15 open issues, **read from their
bodies**, per ADR-001 § 6's warning that the ShelterSync pass was judged from titles and
labels and got at least two of them wrong.

| Item | Category | Reasoning |
|---|---|---|
| #242 | Committed → 1.0 | The release cannot exist without its identity. |
| #246, #247, #248, #251–#256 | Committed → 2.0 | csk phases 1–3. 2.0's promise *is* these: acquisition (#246, #253), the substrate #248 needs (#247), and the scaffold-and-merge upgrade (#248). |
| #249 | Committed → 2.0 | **Derived, not assumed.** Phase 4 looks like a purity stamp, and the test says otherwise: 2.0 promises Windows, and shipped `.sh` files do not run there. A Windows project scaffolded with `ai/scripts/*.sh` in it is a broken install, so the promise fails the **need** limb without this. |
| #257 | **Triggered** | Homebrew tap and Scoop bucket. The `curl … \| sh` installer satisfies 2.0's promise alone; these are better routes, not required ones. Event: the two public repositories exist. Labelled `triggered`, event recorded on the item. |
| #160 | **Out** of both | T31 unattended execution. A new capability class; neither promise fails without it. Its release home is decided when it is next picked up. |
| #161, #162 | **Stretch** | T34 and T35 grills. No promise depends on them, and stretch needs no mechanism. |

**1.0's milestone came out of the forward pass holding one issue — its own.** That is the
expected shape for a release whose promise describes what a product already does, and it is
exactly why the reverse pass and the gate run are the substance here rather than the
formality. A forward filter can only sort what exists.

### 5.2 Reverse pass

Walked per party, per step. Output is **candidate questions**; the resolution column is
what a human adjudicated them to.

**Party — the adopting developer.**

| Step | Requires | Resolution |
|---|---|---|
| Find | The repository | Already handled — 1.0's audience is defined as people who have it. Findability is 2.0's problem. |
| Acquire | `git clone` | Already handled — `README.md`. |
| Install | Scaffold, then fill | Already handled — `scaffold.sh` + `/bootstrap` + `bootstrap/SETUP.md`, evidenced by `bootstrap-smoke.sh` on ubuntu and macos. |
| Operate | Standards, commands, the session protocol | Already handled — `docs/kit/WORKFLOW.md`. |
| Take a later release | Knowing one exists, and what taking it does | **Gap → #258.** No shipped document describes the upgrade path at all; the mechanism is the kit-delta lens, buried fifth of seven inside `/evergreen`. An adopter who never runs an evergreen review never learns a new release exists. T18 predicted this: *"a project scaffolded from kit v0.3 never learns about v0.5."* |
| Take a later release | Knowing what left the kit | **Gap → #265.** No delete path means a removed file stays in every adopter repo forever, with dangling references in the files that did update. Removing `docs/decision-log.md` took a 34-reference sweep upstream; adopters got none of it. |
| Take a later release | A stable upgrade marker | Already handled elsewhere — `bootstrap/KIT_VERSION` has no schema and three ad-hoc parsers, but #248 makes it the three-way merge base and will have to formalise it. Not 1.0 scope. |
| Report a problem | A channel, and a posture | **Gap → #259** (`SECURITY.md`; also the security-posture gate). |
| Know what to expect | A support commitment | **Gap → #260** (also the fired triggered gate). |
| Contribute | `CONTRIBUTING.md` | **Triggered**, decided 2026-08-12 — the event is the first outside PR. Recorded, not missing. |

**Party — the maintainer.**

| Step | Requires | Resolution |
|---|---|---|
| Cut a release | `release.sh` at an alternate root | Already handled — #45, exercised by `bootstrap-smoke.sh`. |
| Cut a release | A parseable CHANGELOG | **Gap → #264.** The `## [0.13.0]` heading is glued to the previous bullet, so the kit's only three `**BREAKING:**` entries are invisible to any heading-based read. |
| Cut a release | Guidance that matches the standard | **Gap → #263.** `/release` step 4 still defines MAJOR as an *"API is stable"* decision — the pre-ADR-001 wording, in the shipped copy too. |
| Re-derive the instance | `self-conform --upgrade/--apply` | **Gap → #262.** The Seeded/derived classification is hand-maintained with no check, so a new founding doc gets silently overwritten. #244 fixed the instance; the class is still open, and both affected files now hold real content. |
| Evidence the promise | `upgrade-smoke.sh` | Already handled, with a question recorded: it tests one hop from the second-newest tag, which evidences *a* release rather than *any* 1.x. Adequate for 1.0; revisit at 2.0 when #248 replaces the mechanism. |
| Run the tracker the kit prescribes | The shipped label set | **Gap → #261.** Fourteen labels from the shipped table do not exist here, including every `severity:*`. The kit distributes automation it has never completed a run of — a T36 self-hosting defect, and the finding underneath the finding. |
| Accept an outside contribution | `CONTRIBUTING.md` | Triggered, as above. |

**Resolution rate:** seventeen candidates, **eight genuine gaps**, six already handled,
three resolved to decisions rather than issues. A higher gap rate than the worked
derivation's two-in-six, which is what a first pass against a never-assessed subject should
look like — and the three "already handled" and three "decision" answers are the healthy
part. *"A reverse pass that reports only confirmed gaps has been filtered by the same blind
spot it exists to defeat."*

**The reverse pass earned its place.** Six of the eight gaps — every one on the maintainer's
row, plus the upgrade documentation — are invisible to any backlog filter, because no issue
existed to filter. #261 in particular is the kind of thing only a walk finds: nothing was
wrong with any tracked item, and the kit had simply never finished running its own script.

---

## 6. Readiness

The full walk, with dated evidence, is the release record: **`docs/releases/RELEASE-1.0.md`**.
What belongs here is the reasoning behind the answers that were not obvious.

**Step 3 could not run.** `/readiness` asserts against `AC-`/`INV-`/`NFR-` rows, and the
kit has none — the register's sections are empty skeletons and there is no journey registry
(§ 2.3). The record says so in place of a table, and the backfill is **#268**. An absent
row and a considered "not applicable" look identical otherwise.

**Two universal gates needed a mapping rather than a verdict**, and inventing one quietly
would have been the wrong move — that is what makes them port-backs (§ 7):

- *A tested restore* has nothing to bite on where there is no data, but the question behind
  it does: can the consumer get back to where they were before taking the release? For the
  kit that is one piece of evidence, shared with *rollback planned and demonstrated*.
- *External providers verified in production* reads as empty for a product with no runtime.
  It is not empty — it is the distribution channel, which is why the row goes from N/A at
  1.0 to load-bearing at 2.0.

**Two triggered gates fired**, and both were things nobody had written down:

- *Has users who depend on it* — three named projects. Owes a documented support
  commitment; **#260**.
- *Publishes policies* — an open-source project publishes the README's claims and the
  LICENSE, which are auditable the same way a privacy policy is. The audit is part of the
  gate run; `SECURITY.md` is **#259**.

**The gate walk found nothing 1.0 cannot reach.** Every unevidenced gate has an issue and
every issue is in the milestone, which is the state the framework is trying to produce.

---

## 7. What did not fit — port-backs to the framework

Five findings. The issue's framing: *"If a universal gate genuinely does not apply to this
archetype, that is itself a finding about the framework, and worth porting back."*

| # | Finding | Home |
|---|---|---|
| **P1** | **One artifact, both archetypes.** The standard says *"pick one per versioned thing"* and assumes the two identities move independently. It has no rule for a single artifact with both users and integrators on one number, which is what the kit is and what T32.13 forces. Two MAJOR triggers, one number, no tiebreak. | **#266**, committed to 1.0 |
| **P2** | Restore and rollback collapse into one gate for a product with no runtime. | #267, stretch |
| **P3** | "External providers verified in production" means the distribution channel for anything distributed, verified by a real install per platform. | #267, stretch |
| **P4** | The policy limb for open source: the published documents are README claims, LICENSE and SECURITY.md. The limb fires; only the document set differs. | #267, stretch |
| **P5** | The need limb where the journey registry legitimately cannot exist — the review module's trigger is a driveable UI. Journeys need another home, and the record needs a judged-vs-checked stamp. | #267, stretch |

**P1 is committed and the rest are not**, because P1 is the one the kit has already acted
on: the archetype row in `docs/releases/README.md` states a rule the shipped standard does
not contain, so the instance and the standard disagree about a live question, and T36 does
not allow that. P2–P5 improve the framework; no promise fails without them.

**A caution for whoever implements #267.** These came from *one* additional subject. Two
derivations is not a pattern, and the framework's own warning about generalising from a
single product applies to its second product too.

**What did *not* need porting**, which is the more interesting half of a generalisation
test: the promise sentence, releases in sequence, the four membership categories, the
forced-choice test, the milestone-as-manifest rule, the both-directions pass, and the
universal/triggered/aspirational split all worked unmodified on a subject the framework had
never seen. The reverse pass in particular did the job it was designed for — it found six
gaps that no backlog filter could have surfaced, because no issue existed to filter.

---

## 8. Consequences for records already written

- **ADR-001 § 4** rejected porting a CLI on the grounds that *"it would breach T2 (POSIX
  shell, bash 3.2) and T22 (context economy)."* T32 reversed that on 2026-08-13 — the kit
  now ships a compiled tool, and T2 is partially superseded. The *decision* ADR-001 records
  stands; only that alternative's rejection reason is historical. Noted in place, not
  superseded.
- **ADR-001 § 6** bullet 1 is closed by this doc and the rows it produced.
