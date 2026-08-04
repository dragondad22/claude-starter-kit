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
