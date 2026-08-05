*Generic standard from the Claude starter kit — adapt to this project. Replace `{{TOKENS}}`; see `bootstrap/PLACEHOLDERS.md`.*

# Release Standard

Owner: {{PROJECT_OWNER}}
Status: Recommended default
Last Updated: 2026-08-04

How {{PROJECT_NAME}} decides what a release **is**: who it is for, what it promises
them, and what its version number means. The CHANGELOG rules and the mechanics of the
bump live in `ai/STANDARDS/VERSIONING_AND_CHANGELOG_STANDARD.md`; this standard answers
the questions that one cannot.

---

## TL;DR

- **A release is a promise to a named audience, stated in one sentence.** Write the
  promise before scoping the release.
- The promise **names every party it must satisfy**, including the business. A promise
  naming only the user describes software, not a product.
- **A product usually has several releases in sequence** — limited availability before
  general availability. Naming them is what makes "what is 1.0?" answerable.
- **Two archetypes**: *contract-versioned* (MAJOR = a named audience's integration
  breaks) and *release-versioned* (MAJOR = a committed promise lands). A project can be
  both, and the two identities move independently.
- **Breaking is always breaking *for whom*.** A claim that cannot name the audience
  whose contract broke is not a breaking change.
- **Membership is a forced choice** — *"would you delay the release for this?"* — with
  four outcomes: committed, stretch, **triggered**, out.
- **Four limbs answer it, three of them objective**: policy (read what you publish),
  platform/legal (read the rules), commercial (can money move), need (judgment). An item
  is committed if it fails **any** limb.
- **The milestone is the manifest.** Membership belongs to the release, not to the
  issue, because a milestone supplies an owning moment and a label cannot.
- **Run the pass in both directions.** Forward filters the backlog; **reverse walks the
  promise and finds what nobody wrote down.** Reverse output is candidate questions.
- **Journeys, not user stories, answer "would the audience's work fail without this?"**
- Release identity is recorded in `docs/releases/README.md` and answered when the
  project first has something to version — not only at inception.

---

## Why this exists

SemVer versions a **contract**. It answers one question, for one audience — *"will
upgrading break my integration?"* — and answers it well. Most projects ship a
**product**, and a product's stakeholders ask a different question: *"is it ready?"*
SemVer has no form for that answer, so two failures follow, and both are common:

- The project **drifts on `0.x` indefinitely**, because nothing ever asks the 1.0
  question and `1.0.0` is defined as a one-time judgement call nobody is routed to. To a
  reader, `0.x` says "unstable, still under development" long after it stopped being
  true.
- Or MAJOR gets bumped **on feel**, because "big" and "breaking" are not the same thing
  and only one of them is defined. A runtime upgrade looks breaking under the usual
  wording and should trigger nothing; a finished product milestone does not look
  breaking at all and is exactly the event worth marking.

The fix is not a better rubric for the number. It is to name the thing the number is
counting, which is a **promise**.

---

## The promise

> **A release is a promise to a named audience, stated in one sentence.**

Everything else in this standard derives from that sentence, so it is worth writing
carefully. A good promise:

- **Names the audience** — not "users", but the specific group who will hold you to it
  ("the pilot customer and invited teams", "anyone who signs up").
- **Names every party it must satisfy, including the business.** A promise phrased only
  in the user's terms describes software; a product also has to be findable, acquirable,
  and payable-for. If there is no way to sign up, there is no product — there is a
  website and an application.
- **States an outcome, not a feature list.** "A pilot shelter runs its daily animal-care
  operation on production" is a promise. "Ships the foster module and the reporting
  screen" is a manifest, and it is downstream of the promise, not a substitute for it.
- **Is falsifiable.** You can point at a real person in the audience and ask whether they
  can do the thing. If nobody could tell you whether the promise is kept, it is a slogan.

Write it down before scoping. A vague promise produces a vague manifest, and the vagueness
is not discovered until the release is late.

---

## Releases in sequence

**A product's releases are several promises in order, not one promise refined.** The
common shape:

| Release | Promise | Audience | Commercial scope |
|---|---|---|---|
| **Limited availability** | A named pilot customer runs its real work on production, provisioned by hand | The pilot, plus invited others | None |
| **General availability** | Anyone can find it, sign themselves up, use it, and be billed | The market | All of it |

When these are not named separately they **collide in one undefined version**, and the
question "what is 1.0?" becomes unanswerable — not because it is hard, but because it is
two questions wearing one label. Naming them is usually the whole fix: one of them is
close, the other is a much larger body of work, and that was never visible while they
shared a number.

**"Pre-release" is the framing to resist.** A limited-availability release sheds
*commercial* scope, not *readiness* scope. The pilot will depend on it in production, so
it still owes a tested restore, verified external providers, a security posture, a
demonstrated rollback, and a documented support commitment. Calling it a pre-release
invites the reading that those are optional, which is the one reading that can hurt
someone.

**A release that narrows its audience does not narrow its obligations to the audience it
keeps.** Published commitments — a privacy policy, a store listing, a terms document —
bind when real user data reaches production, not when money changes hands.

---

## The two archetypes

Pick one per versioned thing. A project may be both at once: an application with a public
API versions the API as a contract and the product as a product, and the two identities
move independently.

### Contract-versioned

The thing has integrators — a library, an API, a CLI, a wire format, a schema. Its
audience is whoever builds against it.

- **MAJOR** — a named audience's integration breaks. This is **mechanical**: it follows
  from a `**BREAKING:**` entry in the CHANGELOG, and needs no judgement.
- **MINOR** — capability added, integrations unaffected.
- **PATCH** — fixes and security only.

### Release-versioned

The thing has users rather than integrators — an application, a service, a product. Its
audience is whoever depends on it to get work done.

- **MAJOR** — a **committed promise lands**: a new promise to a new audience. General
  availability after limited availability is a MAJOR; so is the first release that a
  named audience is invited to depend on.
- **MINOR** — capability added inside the current promise; the increments between one
  named release and the next.
- **PATCH** — fixes and security only.

Under this archetype `1.0` is **reachable**: it is the first named promise landing, and
the answer to "when?" is a burn-down of that release's manifest rather than an argument.

### Breaking is always breaking *for whom*

A list of what counts as a breaking change is only usable once it names the audience
whose contract broke. Removing a request field breaks integrators. Changing an
authorization rule breaks whoever relied on the old one. Upgrading the language runtime
breaks **nobody with a contract**, unless the runtime version is itself something you
published.

> **Every breaking-change claim names the audience whose contract broke. If you cannot
> name one, it is not a breaking change** — it is a change, and it belongs in `Changed`.

---

## Membership — what is in this release

Once a release has a promise, every candidate item gets one question:

> **Would you delay the release for this?**

That is deliberately not *"is this valuable?"*. "Valuable" is unbounded, and two
people — or two sessions — will rank the same backlog differently. "Would you delay
the release" has a **cost attached**, and a question with a cost attached reproduces.

| Answer | Category | Where it lives |
|---|---|---|
| Yes | **Committed** | In the release's milestone |
| No, but take it if it is ready in time | **Stretch** | Outside the milestone — no mechanism needed |
| No, and out **until a named event fires** | **Triggered** | Outside the milestone, with its trigger recorded on the item |
| No | **Out** | Outside the milestone, dated and reasoned |

**Stretch needs no mechanism.** The milestone is the commitment, so anything outside
it is opportunistic by definition. A second list of "probably" items is a list nobody
maintains and everybody reads as a promise.

**Triggered is the category most projects are missing.** A developer API portal is out
*until outside integration requests start*; a compliance-certification track is out
*until a customer contract requires it*; a cross-region failover is out *until an
availability commitment exists*. Filed as "out" they look abandoned and get quietly
re-litigated; filed as **triggered** they are dormant commitments that activate on
their own terms. A triggered item records **the event, not a date** — unless the event
*is* a date, as with a recurring annual obligation.

### The four limbs — how the test is answered

**Reproducibility is the design constraint here.** A framework two sessions cannot agree
on is worthless: it produces a different manifest each time it is run, and a manifest
that moves is not a commitment. So the test is not answered by intuition. It is routed to
evidence first, and to judgment only where nothing else can decide it.

| Limb | The question | Decided by | Reproducible? |
|---|---|---|---|
| **Policy** | Do we already promise this publicly? | Privacy policy, terms, store listing, marketing claims | **Yes** — read the document |
| **Platform / legal** | Does a rule outside us require it? | Store policy, privacy law, payment rules — recorded in `docs/compliance/COMPLIANCE_REGISTER.md` | **Yes** — external and citable |
| **Commercial** | Can money move without it? | Can a customer acquire the product and pay for it | **Mostly** |
| **Need** | Would the audience's work fail? | Journeys required by the promise (below) | **Yes, once journeys exist** |

> **An item is committed if it fails *any* limb.** They are not weighed against each
> other, and three of the four never require an opinion.

Three habits keep it reproducible in practice: **route to evidence before reaching for
judgment**; where judgment is unavoidable, use the forced choice with a cost attached
rather than an open-ended "is this valuable?"; and **record the outcome so it is never
re-derived** — variance then only ever affects first triage.

#### The policy limb is the sleeper

It is the limb most projects never think to run, and the cheapest one to run: **read what
you have already published.** In the worked derivation, auditing a live privacy policy
confirmed four committed items **from a document rather than from judgment**, and
surfaced a fifth — a "right to correct" promised in public with nothing anywhere tracking
it. Nobody had decided not to build it. Nobody had noticed it was owed.

It also produces the result that most reliably surprises people:

> **A limited-availability release carries the same policy and platform obligations as
> general availability.** A published policy binds when real user data reaches
> production, not when money changes hands.

Narrowing the audience drops the **commercial** limb entirely and leaves the other three
untouched. Membership changes **by limb, not by proportion** — which is the concrete
reason "pre-release" is the wrong word for a smaller release (§ Releases in sequence).

### Run the pass in both directions

**A filter over the backlog inherits the backlog's blind spots.** Applying the test to
every tracked item answers *what of our work belongs in this release?* — and cannot,
even in principle, answer *what does this release require that nobody has written down?*

So the pass runs twice, in opposite directions:

| Pass | Method | Answers |
|---|---|---|
| **Forward — filter** | Take each tracked item, apply the test, categorise | What of our work belongs here |
| **Reverse — derive** | Walk the promise as a journey, **per party**, and enumerate what it requires; check each requirement for coverage | What this release requires that nobody wrote down |

Only the reverse pass finds an **absence**. Run against a real product, it surfaced
organisation self-registration — the step that turns an application into a product —
tracked nowhere, while eleven issues carried a commercialization label and made the area
look thoroughly covered. A forward filter reported that area as healthy, because a filter
can only sort what already exists.

Walk it per party. The promise names everyone it must satisfy (§ The promise), so each
party gets its own row: how they **find** it, **sign up**, **operate** it, and — where
the business is a party — how it **gets paid**. Each step names what it requires and
whether anything tracks that.

**Reverse-pass output is candidate questions, not findings.** Of six requirements raised
in the worked derivation, two were genuinely untracked, one was a conflict needing a
decision rather than an issue, and three resolved to *"already handled elsewhere"* once a
human adjudicated them. That resolution rate is healthy — **the value is in the question
being asked**, not in every answer being a gap. A reverse pass that reports only
confirmed gaps has been filtered by the same blind spot it exists to defeat.

### Where "would the audience's work fail?" is answered from

The question *"does the audience actually need this?"* is the one that most tempts a
guess. It has a source, and the source is **journeys** — not user stories.

**A proposed user story is not standing truth.** The product does not do it yet, so
filing one per backlog item would make the register a second tracker, duplicating the
issue that already exists. `US-` rows describe what the product **does**; intent belongs
in the tracker and in specs, which are proposals by design.

Where the review module is installed, `docs/uat/JOURNEY_REGISTRY.md` is already *"the
durable list of flows that must keep working"* — exactly the artifact this question
needs, and walking the promise to enumerate its journeys **is** the reverse pass. One
artifact, one operation, no duplication.

> **The need test: does a journey this release's promise requires fail without this
> item?**

Coverage then falls out of the same walk:

| Condition | What it means |
|---|---|
| A required journey with **no registry row** | The promise depends on a flow nobody has written down |
| A registry row with **no covering issue** | Committed scope nobody is building |
| A registry row still **unverified** | Built but not accepted — a *readiness* gap, not a scope gap |

**Journeys split three ways against a promise**, and that split is what keeps the answer
honest rather than generous:

- Required by the promise and **not yet working** → **scope**. The release adds it.
- Required by the promise and **already working** → a **regression gate**. The release
  must not break it.
- **Not required** by the promise → not this release's business.

For a product already in production nearly every daily-operations journey is the second
kind. That is what makes a later release's scope pass *short* — not what makes its bar
*lower*.

**An existing product needs a backfill first, and it is real work.** Converting what the
product does into journeys is the precondition for this question being answerable from a
document rather than judged. Two traps when doing it: a capability list written as prose
drifts silently (one measured at **thirteen minor versions stale**, with its own header
and footer disagreeing about their date), and **platform facts are not capabilities** —
"PostgreSQL" and "Docker" are not journeys, because no user experiences them and nobody
can accept them.

Without a journey registry the walk still runs and is still worth running; its output is
simply judged rather than checked, and the backfill is what upgrades it.

### The milestone is the manifest

**Membership is a property of the release, not of the issue.** Record it as the
release's milestone in {{ISSUE_TRACKER}} — never as a label on the item.

A label has to be re-judged every time the release definition moves, and nothing
prompts anyone to do that. Observed in practice: a project labelled its scope on the
issues, the definition of that scope drifted, and the label decayed into roughly thirty
freeform variants that could not be counted — so nobody could say what was in, and the
team finished the release and moved on **without noticing it had happened**. An
adjective has no completion event. A milestone burns down.

**Scope change needs an owning moment.** The strongest case for this came from an
issue whose scope changed in a feedback conversation and never reached the record: it
still carried the wording that put it out of scope, months after the audience had asked
for it, because nobody was ever prompted to re-file it. This is the project's own
"decisions in conversation are not authoritative until recorded" rule applied to release
scope — and **adding an item to a milestone is the moment that records it**.

### Three rules that keep a manifest honest

- **Deferral is a recorded removal with a reason**, not a silent drop. Take the item out
  of the milestone, say why, and date it. Otherwise a release quietly shrinks until it is
  trivially complete, and "we shipped everything we committed to" stops meaning anything.
- **An item that is partly in and partly out is a membership bug — split it, do not
  judge it.** "Half of this is committed" is not an answer the test can produce; it means
  the item is two items, and one of them belongs in the milestone.
- **The pass is only as good as what it read.** Judging a backlog from titles and labels
  is fast and unreliable — a real 75-issue pass produced at least one stale label and one
  misleading title, both of which changed the answer. Read the item, and check whether
  anything said about it since was never written down.

---

## Recording release identity

Release identity is project data, not a standard, so it lives in
**`docs/releases/README.md`**: the archetype (or one per versioned thing), and the named
releases in sequence with their promises and audiences.

**When it is asked.** Not only at inception — most projects cannot answer it before they
have something to version, and the answer moves as the product matures and its audience
changes. Two moments own the question:

- **`/bootstrap`** seeds what the inception interview already settled (`Q-SCOPE-05`), and
  records "not yet decided" explicitly when it did not.
- **The session-start release-trigger check** (`ai/agent-setup.md`) asks for it the first
  time a release is actually due and identity is still unrecorded. That is the moment the
  answer costs nothing and is worth something.

Revisit it when the audience changes — a first outside customer, a public launch, a new
integration surface — because that is a new promise, and a new promise is a new release
in the sequence.

---

## See Also

- `ai/STANDARDS/VERSIONING_AND_CHANGELOG_STANDARD.md` — the CHANGELOG, the bump
  mechanics, the release trigger, and how a cut is performed
- `ai/STANDARDS/TASK_ISSUE_STANDARD.md` — milestones mean releases only
- `ai/STANDARDS/ROADMAP_STANDARD.md` — feature intake and Horizon, which order *intent*;
  a release commits *scope*
- `docs/releases/README.md` — this project's recorded release identity

---

## Revision history

| Date       | Author      | Change |
|------------|-------------|--------|
| 2026-08-04 | Starter kit | Created: release identity — the promise, releases in sequence, the two archetypes, breaking-for-whom |
| 2026-08-04 | Starter kit | Membership added: the delay test, four categories, the milestone as the manifest |
| 2026-08-04 | Starter kit | The reverse pass added; journeys named as the source for "would the audience's work fail?" |
| 2026-08-04 | Starter kit | The four limbs added, with reproducibility stated as the design constraint |
