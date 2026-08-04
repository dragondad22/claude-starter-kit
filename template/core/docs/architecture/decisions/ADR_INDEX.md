<!-- Generic template from the Claude starter kit. Replace {{TOKENS}}; see bootstrap/PLACEHOLDERS.md -->
# Architecture Decision Record (ADR) Index

{{PROJECT_NAME}}

**Updated:** YYYY-MM-DD

<!-- A date. Nothing else. What changed belongs in the row it changed — an index
     whose update stamp grows into a narrative is an index with nowhere to put
     relationships, which is the failure the "Relates to" column exists to fix. -->

This index tracks all architectural decisions for {{PROJECT_NAME}}:
- Completed ADRs
- In-progress ADRs
- Planned future ADRs
- Open decision gaps

Status labels: **Proposed** | **Accepted** | **Rejected** | **Superseded**

---

## ADRs

**Why this table carries relationships.** ADRs are separate files because each is
long enough that you would regret loading its neighbours — but the cost of that
split is that *how decisions relate* becomes invisible without opening all of
them. Nobody opens forty files to find out whether a new decision collides with an
old one. This column pays that cost back: it is the only place the shape of the
decision set is visible at once.

**Rules:**

- **One line per row.** Prose accumulating here recreates the problem. Detail
  belongs in the ADR.
- **By ID, never by path** — `revises ADR-023`, not a filename.
- **Written in the same PR as the ADR**, copied from its `Relates to:` field. An
  ADR that revises another and doesn't say so here is an incomplete change.
- **Both ends get updated.** When ADR-B supersedes ADR-A, ADR-A's Status becomes
  `Superseded` and its own row names ADR-B. A one-way link tells you a decision
  was replaced only if you happen to read the replacement first.

| ADR # | Title | Status | Relates to | File |
|-------|-------|--------|------------|------|
| ADR-001 | (first decision title) | Proposed | — | `ADR-001-<slug>.md` |

<!-- WORKED EXAMPLE — delete once real ADRs exist.
| ADR-023 | Activity category lookup | Superseded | superseded by ADR-049 | `ADR-023-activity-category-lookup.md` |
| ADR-049 | Reference operator-managed lookups by id | Accepted | revises ADR-023; companion to ADR-050 | `ADR-049-lookup-references-by-id.md` |
| ADR-050 | Record change-capture, history & restore | Accepted | companion to ADR-049 | `ADR-050-record-change-capture.md` |
-->

<!-- Relationship verbs: revises · supersedes · amends · depends on · companion to.
     Reach for another only when none of these fits. -->


---

## Planned / Future ADRs

| ADR # | Decision Area | Notes |
|-------|---------------|-------|
| ADR- | (area to be decided later) | |

---

## Open Decision Gaps

Topics that influence architecture but do not yet have ADRs:

- (gap 1)
- (gap 2)

---

## ADR Template

See: `ADR_TEMPLATE.md`
