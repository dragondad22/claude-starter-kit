<!-- Generic seed from the Claude starter kit. Replace {{TOKENS}} and the worked example; see bootstrap/PLACEHOLDERS.md -->
# Releases — {{PROJECT_NAME}}

**What a release of {{PROJECT_NAME}} promises, and to whom.** The rules behind this file
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
| | | | YYYY-MM-DD |

<!-- WORKED EXAMPLE — delete once real rows exist.
| The product | release-versioned | A committed promise lands — a new promise to a new audience | 2026-08-04 |
| `/api/v1` | contract-versioned | An integrator's calls stop working | 2026-08-04 |
-->

**Not yet decided?** Say so here in one line, with the date. An unanswered archetype and a
deliberately deferred one look identical otherwise, and the session-start release-trigger
check will keep asking until one of them is written down.

---

## Releases in sequence

*The promise is one sentence naming the audience and every party it must satisfy. Add a
row when a release is named, not when it ships.*

| Release | Version | Promise (one sentence) | Audience | Status |
|---|---|---|---|---|
| | | | | |

<!-- WORKED EXAMPLE — delete once real rows exist.
| Limited availability | 1.0 | A pilot shelter runs its daily animal-care operation on production, provisioned by us | The pilot shelter and invited others | Planned |
| General availability | 2.0 | Anyone can find it, sign their organisation up, operate it, and be billed | The market | Planned |
-->

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
lives in its milestone in {{ISSUE_TRACKER}}. A record cites the milestone; it does not
mirror it, because a mirrored list drifts and a drifted manifest is worse than none.
