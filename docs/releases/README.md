# Releases — Claude Starter Kit

**What a release of Claude Starter Kit promises, and to whom.** The rules behind this file
are in `ai/STANDARDS/RELEASE_STANDARD.md`; what lives here is this project's answers.

Two things live in this directory:

- **Release identity** — below: the archetype, and the named releases in sequence with
  their promises. This is the file's main job.
- **Release records** — one file per release, holding what was promised, what shipped,
  and the evidence behind it.

---

## Archetype

*One row per independently versioned thing. Most projects have one; a product with a
public API has two, and they move independently
(`ai/STANDARDS/RELEASE_STANDARD.md` § The two archetypes).*

| Versioned thing | Archetype | What MAJOR means here | Decided |
|---|---|---|---|
| The kit — the `template/` payload, the process it ships, and `csk` in lockstep (T32.13) | release-versioned | A committed promise lands — a new promise to a new audience | 2026-08-14 |

**One artifact, two audiences, one number.** The kit has users (project owners, who read
the standards and run the commands) *and* integrators (adopter repositories, whose on-disk
state depends on file paths, `bootstrap/KIT_VERSION`, the `{{TOKEN}}` registry and the
script interfaces). Both archetypes would claim MAJOR, and T32.13 puts everything on one
number. **The promise wins**: a change that affects adopters is still declared
`**BREAKING:**` naming whose contract broke, but does not force a MAJOR — the scaffold has
no delete path and never overwrites, and csk phase 3 (#248) makes upgrade a three-way
merge, so an adopter break is repairable rather than integration-fatal. Reserving MAJOR for
promises keeps the number saying one thing.

The **event-log format** (#247) is the one part that genuinely moves independently — T32.9
makes it versioned and self-describing so a separate implementation can read it. It takes a
contract-versioned row of its own, versioned inside the log, when it exists.

Source: `docs/plans/2026-08-14-kit-release-identity.md` (#242).

**Not yet decided?** Say so here in one line, with the date. An unanswered archetype and a
deliberately deferred one look identical otherwise, and the session-start release-trigger
check will keep asking until one of them is written down.

---

## Releases in sequence

*The promise is one sentence naming the audience and every party it must satisfy. Add a
row when a release is named, not when it ships.*

| Release | Version | Promise (one sentence) | Audience | Status |
|---|---|---|---|---|
| Safe to depend on | 1.0 | A developer who has this repository can install the kit into a new or existing project, run that project by it from inception through release, and take a later kit release without losing or damaging what they have adapted | The named adopters (CrossWise, ShelterSync, life-os) and anyone who clones the repo | Planned |
| Acquirable | 2.0 | Anyone can find the kit, install it without cloning anything, scaffold a project from the tool alone on macOS, Linux or Windows, and upgrade an existing project across releases with their edits merged rather than skipped | The market | Planned |

Both promises name a second party, the **maintainer** — who must be able to cut a release
and re-derive the kit's own instance from it (1.0), and to publish binaries every adopter's
CI can find on PATH (2.0). There is no commercial party: MIT, no money, so that limb is
empty and acquisition carries what it would have.

1.0's last clause is deliberately weaker than 2.0's. *Without losing or damaging* is what
the additive scaffold guarantees today and what `scripts/upgrade-smoke.sh` asserts;
*with their edits merged* needs the three-way merge in #248. A promise should not claim
what its own test declines to assert.

Status is `Planned`, `In progress`, `Shipped`, or `Abandoned (<date>, reason)`. A release
that is abandoned is recorded, not deleted — the promise was made somewhere, and the
record is where someone finds out it was withdrawn.

---

## Release records

One file per release, named `RELEASE-<version>.md`, from
`ai/TEMPLATES/RELEASE_READINESS_TEMPLATE.md`. A record holds what was promised, what
shipped against it, and the **gate evidence with dates** — it is written as the release
is prepared and kept afterwards, because "what did we actually promise in 1.0?" and "what
did we actually verify?" are both asked long after the tag is cut, usually during an
incident.

The scope itself is **not** copied here: membership is a property of the release and
lives in its milestone in https://github.com/dragondad22/claude-starter-kit/issues. A record cites the milestone; it does not
mirror it, because a mirrored list drifts and a drifted manifest is worse than none.
