# Draft: ShelterSync 1.0 — worked example for a kit release framework

**Date:** 2026-08-04 · **Revision 4** · **Purpose:** derive the kit's release framework
from a real backlog rather than from theory

**Nothing has been changed in ShelterSync** — no milestone created, no issue edited.
Measured against `Zoolytix/sheltersync` on 2026-08-04: **0 milestones, 75 open issues**,
version `0.26.0`, in production since 2026-05-15.

> **Rev 2 → 3 (Chris):** the pass must also run in reverse; the *need* limb needs a named
> source; "not on the path to the promise" was hiding **triggered** work and at least one
> misclassification; and #439's scope changed in beta feedback without ever being recorded.
>
> **Rev 3 → 4 (Chris):** a release is not one thing — MSR needs production without signup
> or billing, which is a *narrower promise to a narrower audience*, not a "pre-release".
> `Proposed` user stories would make the register a second tracker; journeys are the need
> limb's source instead. Invoice / dunning / tax are already handled by Stripe. Policies
> audited: `apps/docs/legal/`. Stretch needs no mechanism.

---

## 1. Reproducibility

*Would a different session produce the same list?* Four things reduce the variance:

**a. Route to evidence, not opinion.**

| Limb | Decided by | Reproducible? |
|---|---|---|
| **Policy** — do we already promise this publicly? | Privacy policy, store listing, marketing claims, terms | **Yes** — read the document |
| **Platform / legal** | Store policy, privacy law, payment rules | **Yes** — external, citable |
| **Commercial** — can money move without it? | Can a customer acquire and pay | **Mostly** |
| **Need** — will the audience's work fail? | The journey registry (§3) | **Yes, once journeys are written down** |

**b. Sharpen the subjective residue into a forced choice.** Not "is this needed" but
**"would you delay the release for this?"** — a choice with a cost attached.

**c. Record the outcome, so it is never re-derived.** Decided once per item, stored in the
milestone. Variance only affects first triage.

**d. Run the pass in both directions** (§2). A filter over the backlog inherits the
backlog's blind spots; only derivation from the promise finds what was never written down.

## 2. Two passes, not one

**Forward — filter.** Take each tracked item, apply the membership test, categorise.
Answers: *what of our work belongs in this release?*

**Reverse — derive.** Walk the promise as a journey, per party, and enumerate what it
requires. Check each requirement for coverage. Answers: *what does this release require
that nobody has written down?*

The reverse pass is the one that found org self-signup, and it found it by accident in
rev 1. Run deliberately against the promise, it produces this:

| Promise step | Party | Requires | Tracked? |
|---|---|---|---|
| **Find** | Shelter | Marketing site, apex domain | #1083 |
| | | Book-a-demo path | #1084 |
| **Sign up** | Shelter | **Organisation self-registration** | ❌ **no issue** |
| | | First-admin creation, org provisioning | Global-Admin-only today (Decision 7) |
| | | Terms acceptance at signup | ❌ **no issue** |
| **Operate** | Volunteer, staff, admin | The daily workflows | Mostly built |
| **Be billed** | Zoolytix | Billable event defined | #1078 |
| | | Metering ledger | #1080 |
| | | Payment collection | #1081 |
| | | Invoice, dunning, tax | ✅ **already handled by Stripe** — #1081 integrates it |

**The reverse pass produces candidate questions, not findings.** Six requirements were
raised; two are genuinely untracked (org self-registration, terms acceptance), one is a
conflict needing a decision, and three resolved to *"already handled elsewhere"* once
Chris adjudicated them. That resolution rate is healthy — the value is in the question
being **asked**, not in every answer being a gap.

A forward filter would have reported commercialization as well-covered, because eleven
issues carry the label. It cannot see an absence.

*(Provisioning is listed as a question rather than a gap: Decision 7 made it deliberately
Global-Admin-only for MVP, which conflicts with self-signup and needs a decision, not an
issue.)*

## 3. Where the *need* limb comes from

`US-` rows were the wrong answer. **A `Proposed` story is not standing truth** — the
product does not do it — so filing one per backlog item would make the register a second
tracker, duplicating the issue that already exists (#979 is the case that shows it).
Intent belongs in the tracker and in specs, which are proposals by design (T37).

**`US-` rows exist only for what the product actually does.** The need limb's source is the
**journey registry** — already defined as *"the durable list of flows that must keep
working"*:

> **Need test: does a journey this release's promise requires fail without this item?**

Walking the promise to enumerate its journeys **is** the reverse pass (§2). One artifact,
one operation, no duplication. Coverage falls out of it:

| Condition | Means |
|---|---|
| A required journey with no journey-registry row | The promise depends on a flow nobody has written down |
| A journey row with no covering issue | Committed scope nobody is building |
| A journey row `unverified` | Built but not accepted — a readiness gap, not a scope gap |

**For an existing product this needs a backfill.** ShelterSync has done it informally:
`ShelterSync_Features_List_v1.1.md` is a 92-row capability list. Converting the
user-facing rows into journeys — dropping platform facts like "PostgreSQL" and "Docker",
which no user experiences and nobody can accept — is the precondition for this limb being
objective rather than judged.

### The policy limb, audited

`apps/docs/legal/privacy.md` (157 lines) makes specific, testable commitments — which is
what makes this limb objective rather than a matter of opinion:

| Published commitment | Covered by |
|---|---|
| Right to know / access | #1074 |
| Right to delete; deletion completes **within 30 days** | #1071, #1072 |
| **Right to correct** | ❌ **no issue found** |
| Retention periods per category (§6.3) | #1089 |
| Backups expire **within 35 days** | ✅ ADR-051 already sets 35-day production retention |
| Right to opt out of "sale"/"sharing" (§3.1, §6.1) | Partly #985 — but that is Contentsquare-scoped |

Two outputs: four committed items confirmed **from a document rather than judgment**, and
one obligation already promised in public with nothing tracking it.

## 3b. A release is not one thing — name its audience first

MSR's beta testers are not using the product because it is not production, and the CEO
wants to go to production for them. **That delivery needs neither signup nor billing** —
MSR is already provisioned, and nobody is charging them.

Under rev 3's single promise that event was unrepresentable. It is not a "pre-release"; it
is a **release with a narrower promise to a narrower audience**:

| Release | Promise | Audience | Commercial scope |
|---|---|---|---|
| **Limited availability** | A pilot shelter runs its daily animal-care operation on production, **provisioned by Zoolytix** | MSR, invited shelters | None |
| **General availability** | Anyone can find it, sign itself up, operate, and be billed | The market | All of it |

**ShelterSync has two candidate releases colliding in one undefined "1.0"** — which is why
"what is 1.0?" has had no answer. They are not competing; they are sequential, and only
one of them is close.

Under a product archetype **GA is a major** — a new promise to a new audience — so limited
availability is a legitimate `1.0` and GA is `2.0`. That also answers rev 3's open question
about what 1.1 would be: the increments between the two.

**"Pre-release" is the framing to resist.** A limited-availability release sheds
*commercial* scope, not *readiness* scope. MSR will depend on it, so it still owes: a
tested restore, verified production email, security posture, rollback planned and
demonstrated, and a documented support commitment. Calling it a pre-release invites the
reading that those are optional, which is the one reading that could hurt.

**Membership is therefore always relative to a named release.** The pass in §5 is the GA
pass; the limited-availability pass would be a different, much shorter list — mostly the
*need* and *platform/legal* limbs, with the whole commercial limb dropped.

## 4. Four categories, not three

Rev 2's "Out" bucket held 15 items filed as *"not on the path to the promise"*. That
phrase was hiding structure — two different things and at least one error.

| Category | Test |
|---|---|
| **Committed** | Would delay the release |
| **Stretch** | Would not delay it; take it if ready in time |
| **Triggered** | Out **until a named event fires** — the event is recorded with the item |
| **Out** | Not wanted for this release, dated and reasoned |

**Triggered is the missing one**, and it mirrors the gate taxonomy in §6 exactly. Worked
examples from Chris's review:

- **#642 (Developer API docs portal)** — out *until we start taking outside integration
  requests*. That is not a deferral, it is a **dormant commitment with a named trigger**.
  Filed as "out", it looks abandoned; filed as triggered, it activates on its own terms.
- **#1049 (Annual restore exercise, due 2027-07-30)** — date-triggered recurring
  obligation, never release scope.
- **SOC 2 track (#1063, #1064, #1068, #1075, #1076)** — triggered by a customer contract or
  enterprise deal, not by a release.
- **#1052 (Route 53 failover), #1048 (cross-region backups)** — triggered by an availability
  commitment that does not exist yet.

**And one misclassification:** **#977 (capture `docs:shots` for the wave-1 foster
surfaces)** is **user documentation for shipped behaviour**, which the documentation
standard's same-PR keep-current rule already requires. It is **committed**, not out. I
filed it under "tooling / docs" by reading the title rather than the content — exactly the
error a routing rule is supposed to prevent.

## 5. The pass — corrected

### Committed

**Need** (source: the register once backfilled; judged here against the promise)
#1000 *(untriaged — no priority label)* · #1031 *(labelled `medium`; the auth rate limiter
blocks a whole site behind one NAT IP)* · #1033 *(labelled `low`, titled `[Medium]`; silent
data loss)* · #1023 · #1024 · #1025 *(beta-feedback defects, Decisions 82/83/84)* · #1029 ·
**#439** *(see below)* · **#977** *(user docs for shipped behaviour)*

**Platform / legal** — #1071 · #1072 · #1095 · #1074 · #988 *(store data-safety split only)*

**Policy** — #1089 · #1091 · #1092 · #1082

**Commercial** — #1078 · #1080 · #1081 · #1083 · #1084 · **plus 5 untracked** (§2)

### Stretch
#1018 *(Chris's call — wanted, not blocking)* · #1019 · #1085 · #1022

### Triggered
#642 *(outside integration requests)* · #1049 *(2027-07-30)* · #1063 · #1064 · #1068 ·
#1075 · #1076 *(customer contract / SOC 2 engagement)* · #1052 · #1048 · #1053 · #1073
*(availability or security commitment)* · #1086 *(paying customers to notify)*

### Out
Contentsquare analytics (#981 remainder) · foster engagement wave 2 (#888) · explicit
post-MVP decisions (#362, #517, #931) · feature polish (kennel-card variants, photo
gallery, documents, notes review, theme, branding, QR deep link) · #1087 · #1090 · #1093

### #439 — the finding that matters most

**#439 (role management: CRUD roles, assign permissions per org) is labelled `post-MVP` in
its own title. Beta testers asked for it. It was never updated.**

The scope changed in a feedback conversation and the change never reached the record —
which is the kit's own rule (*"decisions made in conversation are NOT authoritative until
recorded"*) applied to release scope, where it has no owning moment.

This is the strongest case in the draft for membership being a **property of the release
with a moment attached** rather than an adjective on an issue. A label has no event: nobody
was ever prompted to re-file #439. A milestone does: adding it is the event.

**It also means the pass I just ran is unreliable in the same way.** I judged 75 issues
from titles and labels, and at least one carried a stale label and one a misleading title.
The pass has to be re-run against issue *bodies* and recent feedback before anyone commits
to it.

## 5b. The limited-availability pass (MSR)

> **Promise: a pilot shelter runs its daily animal-care operation on production,
> provisioned by Zoolytix.** Audience: MSR and invited shelters. Parties: shelter admin,
> staff, volunteer, foster. Zoolytix appears only as provisioner.

### Which journeys belong to it

| Journey kind | Role in this release |
|---|---|
| Required by the promise, **not yet working** | **Scope** — the release adds it |
| Required by the promise, **already working** | **Regression gate** — the release must not break it |
| Not required by the promise | Not this release's business |

ShelterSync has been in production since 2026-05-15, so nearly every daily-operations
journey is already the second kind. That is what makes this pass short — not a lower bar.

### Committed

**Need** — a required journey fails without it
#1031 *(auth rate limiter blocks a whole site behind one NAT IP — **MSR's volunteers all
share the shelter's wifi**; this is the single most release-shaped item in the backlog)* ·
#1000 · #1033 · #1023 · #1024 · #1025 *(the last four are beta-feedback defects — raised by
this very audience)* · #1029 · **#439** *(beta testers asked for it)* · #977 *(user docs for
shipped foster surfaces)*

**Platform / legal** — #1071 · #1072 · #1095 · #1074 · #988 *(store data-safety split)*

**Policy** — #1089 · **plus "right to correct"**, published in `privacy.md` §6 with no
issue tracking it

**Commercial** — *none. The entire limb drops.*

### Dropped relative to GA
#1078 · #1080 · #1081 · #1082 · #1083 · #1084 · organisation self-registration · terms
acceptance at signup — all commercial-limb, and MSR is provisioned by hand.

### The counterintuitive result

**~15 committed for LA against ~22 for GA — and the reduction is *entirely* the commercial
limb.** The platform/legal and policy limbs do not shrink at all.

That is the opposite of the intuition that a beta-shelter release is a lighter compliance
lift. `privacy.md` is **live** — effective 01/01/2026, last updated 2026-08-02 — and it
binds Zoolytix as a **controller for account administration and security** with respect to
"Organization Users", which is exactly what MSR's staff and volunteers are.

> **Going to production for MSR is the moment the published privacy commitments start
> binding against real user data — not later, when money changes hands.**

Right to know, right to delete within 30 days, right to correct, and the published
retention periods all attach at limited availability. Apple's in-app deletion requirement
attaches wherever the app is distributed from, store or TestFlight external testing.

**Decision needed, not an issue:** whether MSR's volunteers install through the App Store
or TestFlight. It changes nothing about *whether* #1071/#1072 are committed — both routes
carry the requirement — but it changes the submission gate's timing.

### What this validates

The claim rev 4 introduced — *different promise, different membership* — holds, but not in
the way predicted. Membership changed **by limb, not by proportion**: one limb vanished
entirely and the others were untouched. A release that narrows its audience does not
narrow its obligations to the audience it keeps.

## 6. Readiness — gates in three kinds

| Kind | Behaviour |
|---|---|
| **Universal** | Every release. Capabilities accepted · external providers verified in production · tested restore · security posture · **rollback planned and demonstrated** |
| **Triggered** | Fires on context. Ships via an app store → submission accepted · publishes policies → every claim honoured *and evidenced* · takes payment → obligations disclosed, billing verified end to end · has dependent users → **a documented support commitment** |
| **Aspirational** | Goals, never gates. SOC 2 today: real, and not realistic at this stage. In a blocking list it stops every release; absent, it never happens. Its tasks become committed **when a criterion fires** |

Same three-way shape as scope in §4 — which is the sign it is the right decomposition
rather than two ad-hoc lists.

**ShelterSync status:** SMS verified in production ✅ · **email prod + OTP unverified** ·
tested restore ✅ (ADR-051, RPO 12h / RTO 24h, measured 3m51s) · encryption ✅ (2026-06-25,
#815) · **rollback: no evidence** · **support commitment: no evidence**.

## 7. What generalizes to the kit

1. **Name the release before scoping it.** A release is a promise to a named audience, and
   a product usually has several in sequence — limited availability before general
   availability. Without naming them they collide in one undefined version and the
   question "what is 1.0?" becomes unanswerable. **This is the finding to lead with.**
2. **The promise names every party it must satisfy**, including the business. A promise
   naming only the user describes software, not a product.
3. **Run the pass in both directions.** Forward filters the backlog; reverse derives from
   the promise and finds what nobody wrote down. Reverse output is **candidate questions**
   — "already handled elsewhere" is a healthy, common answer.
4. **Membership is a forced choice** — "would you delay the release for this?" — with four
   outcomes: committed, stretch, **triggered**, out. Triggered is a dormant commitment with
   a named event, not a deferral. **Stretch needs no mechanism**: the milestone is the
   commitment, so everything outside it is opportunistic by definition.
5. **Four limbs, three objective.** Policy (read what you publish), platform/legal (read
   the rules), commercial (can money move), and need (judgment). Auditing ShelterSync's
   privacy policy confirmed four items and surfaced one obligation — right to correct —
   promised in public with nothing tracking it.
6. **The need limb's source is journeys, not stories.** A `Proposed` user story is not
   standing truth and would make the register a second tracker. `US-` rows describe what
   the product *does*; the journey registry carries what must keep working.
7. **Scope changes need an owning moment.** #439 changed in beta feedback and never reached
   the record, because a label has no event and a milestone does.
8. **Gates are universal, triggered, or aspirational** — the same decomposition as scope,
   which suggests it is the right one. A limited-availability release drops commercial
   scope but keeps every readiness gate.
9. **Every kit gate today is diff-scoped.** `/qa`, `/security`, `/perf`, `/preflight`,
   `/review` all evaluate a change. Nothing evaluates the assembled product.

## 8. Open questions

1. **Which release is being cut first?** Limited availability for MSR looks close and
   answers the CEO's question; GA is the larger body of work.
2. **Decision 7 made provisioning Global-Admin-only for MVP.** Self-signup contradicts it —
   a decision to revisit, not an issue to file. Note it does *not* block limited
   availability, where Zoolytix provisioning is the intended path.
3. **"Right to correct" is published with nothing tracking it.** File it.
4. **The §5 pass is unreliable in the way #439 exposed** — judged from titles and labels,
   at least one label stale and one title misleading. Re-run against issue bodies before
   committing.
