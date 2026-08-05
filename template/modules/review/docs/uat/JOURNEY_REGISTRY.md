<!-- Generic seed from the Claude starter kit — installed with the review module. Replace the worked example with this project's real journeys. See ai/STANDARDS/INDEPENDENT_REVIEW_STANDARD.md for the why. -->
# Journey Registry — {{PROJECT_NAME}}

The durable list of the flows an independent review can walk, and the record of
which ones must keep working. The reviewer agents and the `/review` command read
this file; a run is only as complete as the registry is.

Each journey is one row. IDs mirror the feature-spec convention
(`JRN-<DOMAIN>-NNN`, cross-referencing `SPEC-<DOMAIN>-NNN` when a spec exists).

## Columns

| Column | Meaning |
|---|---|
| **ID** | `JRN-<DOMAIN>-NNN` — stable, append-only |
| **Persona** | a name from `docs/PERSONAS.md` — never redefined here |
| **Journey** | the goal + where it starts, in the persona's terms (a **goal, not steps**) |
| **Entities / vocabularies touched** | the data this flow reads or writes — the **blast-radius key**: a change to any of these pulls this journey into a review even if its own screens didn't change |
| **Criticality** | `critical` or `standard` — a product judgment, set by a human (an agent may propose) |
| **Status** | `discovered`/`authored` × `unverified`/`verified` (below) |
| **Codified spec** | path to the committed regression test, or blank = not yet banked |

## Status values

- **discovered** — a reviewer found the flow exists (a proposal a human merged). Its
  *outcome* is not asserted, because observed behaviour is never turned into a
  done-condition (that would canonise a bug nobody has found yet).
- **authored** — a human (or a feature spec's Journey layer) stated the done-condition.
- **unverified** — no confirmed done-condition yet. **Still worth running:** the
  universal invariants (round-trip, offered-means-accepted, no-silent-failure,
  no-dead-end) hold regardless, so an unverified row still catches the bug class that
  motivated this module.
- **verified** — has a confirmed done-condition the driver checks against.

## What this registry is for at release time

Beyond driving reviews, this file answers the release question *"would the audience's
work fail without this item?"* — which is why it is the source for that limb rather than
`US-` rows, whose job is to describe what the product already does
(`ai/STANDARDS/RELEASE_STANDARD.md` § Membership).

Walking a release's promise enumerates the journeys it requires, and each one lands in
exactly one of three places:

| Against a release's promise | Role |
|---|---|
| Required, **not yet working** | **Scope** — the release adds it |
| Required, **already working** | **Regression gate** — the release must not break it |
| Not required | Not that release's business |

For a product already in production, most rows here are the second kind. Two conditions
read directly off the table: a row with no covering issue is committed scope nobody is
building, and a required journey with **no row at all** means the promise depends on a
flow nobody has written down. An `unverified` row is a *readiness* gap, not a scope gap.

**Platform facts are not journeys.** A datastore or a container runtime has no persona
and no done-condition — nobody experiences it and nobody can accept it — so it never
becomes a row here, however prominent it is in an architecture list.

## Keep-current

A PR that adds or changes a user-facing flow updates this registry in the same PR — a
new row, a changed done-condition, or a changed **entities/vocabularies touched** list
(that last one is what keeps blast-radius scoping honest). Rows with a blank *Codified
spec* are the ratchet backlog; `unverified` rows are the done-condition backlog — this
table is its own coverage view.

## Registry

<!-- WORKED EXAMPLE — delete this row once real journeys exist. -->

| ID | Persona | Journey | Entities / vocabularies touched | Criticality | Status | Codified spec |
|---|---|---|---|---|---|---|
| JRN-BATCH-001 | Roastery apprentice | Log a roast note against today's batch and see it on the batch history | `batch`, `roast_note`, `roast_status` vocabulary | critical | authored, verified | `e2e/batch-note.spec.ts` |
