# ADR-001: A release is a promise to a named audience

**Status:** Accepted
**Date:** 2026-08-04
**Deciders:** Chris (approved 2026-08-04)
**Related ADRs:** (none — first ADR in this repo)
**Source:** Working doc `docs/plans/2026-08-04-release-framework-sheltersync-draft.md`
(five passes against a real 75-issue backlog); epic #224

## 1. Context

The kit decides MINOR and PATCH mechanically from which `[Unreleased]` sections have
entries, and **has no mechanism that can ever produce a MAJOR**. The "After 1.0" section of
`VERSIONING_AND_CHANGELOG_STANDARD.md` is dormant and instructs a human to "flip this
section to active" — a setup block with no workflow owner, the failure class epic #172
exists to stop. Nothing in the kit ever asks the 1.0 question, so a project drifts on `0.x`
indefinitely, and `0.x` reads publicly as "unstable, still under development".

The underlying mismatch, found by working the problem against a real product rather than
in the abstract: **SemVer versions a contract; most projects ship a product.** SemVer
answers exactly one question for exactly one audience — *"will upgrading break my
integration?"* It cannot answer *"is it ready?"*, which is the question a stakeholder
actually asks. Every symptom follows from that: "breaking change" is not a sufficient
trigger, a runtime upgrade (Node 22→24) looks breaking and should trigger nothing, and
"when is the MVP done" has no answerable form.

Derived against ShelterSync — 90 decisions, 54 ADRs, 75 open issues, **zero milestones**:

- The team **completed its MVP and moved on without noticing**. "MVP" was an adjective on
  issues, and adjectives have no completion event; `MVP Scope:` produced 37 plain "In" plus
  roughly thirty freeform variants, which cannot be counted.
- Its manifest existed as prose — a 92-row feature list plus a gap analysis — **thirteen
  minor versions stale**, with a header and footer disagreeing about their own date, and
  listing a gap whose issue was already closed.
- Scope changed in beta feedback (#439) and **never reached the record**, because a label
  has no owning moment.
- Two candidate releases — limited availability for a pilot shelter, and general
  availability — were **colliding in one undefined "1.0"**, which is why the question had
  gone unanswered for months.

## 2. Decision

**A release is a promise to a named audience, stated in one sentence.** Everything else
derives from it.

1. **A product has several releases in sequence**, each with its own promise and audience —
   limited availability before general availability. Naming them is what makes "what is
   1.0?" answerable. Under a product archetype, a new promise to a new audience is a MAJOR.
2. **Two archetypes ship, and a project may be both:** *contract-versioned* (MAJOR = a named
   audience's integration breaks, mechanical from a `**BREAKING:**` entry) and
   *release-versioned* (MAJOR = a committed promise lands). ShelterSync versions its API
   `/api/v1` separately from its product, so the identities move independently.
3. **Membership is a forced choice — "would you delay the release for this?"** — with four
   outcomes: **committed**, **stretch**, **triggered** (out until a named event fires), and
   **out**. Stretch needs no mechanism: the milestone is the commitment, so anything outside
   it is opportunistic by definition.
4. **Membership is a property of the release, not the issue.** The milestone is the manifest
   and supplies the owning moment a label cannot. Deferral is a recorded removal with a
   reason, or a release quietly shrinks until it is trivially complete.
5. **Four limbs decide membership, three of them objective:** policy (read what you
   publish), platform/legal (read the rules), commercial (can money move), and need
   (judgment). An item is committed if it fails any limb.
6. **Scope is derived in both directions.** Forward filters the backlog; **reverse walks the
   promise and finds what nobody wrote down.** Reverse output is candidate questions, not
   findings — "already handled elsewhere" is a healthy answer.
7. **The need limb's source is journeys, not user stories.** A `Proposed` story is not
   standing truth and would make the register a second tracker (T37). Journeys required by
   the promise and not yet working are **scope**; required and already working are a
   **regression gate**.
8. **Readiness is a second axis** with three kinds of gate — universal, triggered,
   aspirational — producing evidence with dates rather than checkboxes. A release ships when
   the milestone empties **and** the gates are green; neither alone.
9. **Breaking is always breaking *for whom*.** A claim that cannot name the audience whose
   contract broke is not a breaking change.

## 3. Consequences

### Positive

- `1.0` becomes reachable rather than perpetually deferred, and the answer to "when?" is a
  burn-down rather than an argument.
- **Reproducibility is designed for, not hoped for**: three of four limbs are answerable
  from documents, the subjective residue is a forced choice with a cost attached, and each
  outcome is recorded once so it is never re-derived.
- A **promise finds missing work**. A backlog filter can only sort what exists.
- Gates stop being a wish list: aspirational goals (SOC 2) neither block every release nor
  vanish.

### Negative

- **An existing product needs a backfill** — its capabilities written down as journeys —
  before the need limb is objective rather than judged. This is real work.
- More ceremony per release than "read the CHANGELOG sections and bump".
- The framework's value depends on a promise sentence that a human must author well; a
  vague promise produces a vague manifest.

## 4. Alternatives Considered

- **Leave MAJOR as a one-time manual call.** Rejected: it is the status quo, and nothing
  ever asks, which is the defect.
- **Trigger MAJOR from breaking changes alone.** Rejected by evidence: a project can stay on
  `0.x` forever, and a runtime upgrade would qualify while a completed product milestone
  would not.
- **Port codex-starter-kit's release machinery** (JSON change records, admission schemas,
  transaction journal, a CLI). Rejected: right for a Go product that builds its own CLI,
  wrong here — it would breach T2 (POSIX shell, bash 3.2) and T22 (context economy). Its
  *concepts* were taken: release triggering separate from version selection, a milestone as
  the finite manifest, and deferral that cannot hide a failed gate.

## 5. Implementation Notes

Epic **#224**, six sub-issues (#225–#230). Sub-issue 6 depends on epic #205's register:
before it, nothing product-wide existed to assert against.

## 6. Follow-Up Actions

- The kit's own release identity is undecided — it is at `0.12.0` and has never been asked
  the question. Apply this framework to the kit itself once shipped.
- The ShelterSync membership pass in the working doc was judged from issue titles and
  labels; at least one label was stale and one title misleading. Re-run against issue bodies
  before anyone acts on it.
