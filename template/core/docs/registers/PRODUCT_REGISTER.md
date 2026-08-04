# Product Register

**Standing truth about what this product must do and be.** A rule recorded here
is the current answer until something supersedes it — not a proposal, not a snapshot
of what was once intended.

- **Feature specs propose; this register holds.** A spec (`docs/specs/`) states what
  was *proposed* for one feature and is consumed at implementation. This file states
  what is *true* across the application, and stays correct after the spec is history.
- **Each row carries its own `Decided` date** rather than the file carrying one stamp.
  A register changes constantly; a single file-level date would be stale the day after
  it was written, which is the failure mode dated documents exist to prevent.
- **Read by** whoever implements a feature, by `/qa`, `/perf` and `/security`, and —
  where the review module is installed — by the independent reviewer agents, which
  need standing truth rather than a proposal that may since have been superseded.

Empty sections below mean *nothing has been recorded yet* — not *nothing applies*.

## The routing rule

One question decides whether something belongs here at all:

> **Would this still be true if this product were rebuilt on a different stack?**

**Yes** → it belongs in this register. Pick the section by what would check it (below).
**No** → it is a decision about how the system is built → **ADR**
(`docs/architecture/decisions/`).

That test resolves on its own. It never requires looking at what was filed before —
"check existing patterns and follow precedent" is how a register decays into a
catchall, and it is explicitly not the rule here.

### What belongs somewhere else

| If the content is… | It goes to | Because |
|---|---|---|
| Structure, technology, data model, integration approach | `docs/architecture/decisions/` (ADR) | It would not survive a rebuild |
| What a term means | `docs/GLOSSARY.md` | It is vocabulary, not a rule |
| How *we* work — branching, naming, review, commits | `ai/STANDARDS/` | It binds the team, not the product |
| An obligation imposed on us from outside | `docs/compliance/COMPLIANCE_REGISTER.md` | It needs an owner and a verified date |
| Whether or when something gets built | The issue tracker (+ Horizon) | Scope is a plan, not standing truth |
| Who the users are | `docs/PERSONAS.md` | Already a register |
| A flow that must keep working | `docs/uat/JOURNEY_REGISTRY.md` (review module) | Already a register |

A decision that both settles architecture *and* establishes a product rule produces
**both** an ADR and a register row — the row states the rule and cites the ADR. It is
never recorded twice in full.

## How an entry is written

**IDs are permanent addresses.** `BR-014` is `BR-014` forever: never renumbered, never
reused after a supersede, never renumbered by reordering or reorganising this file.

**Cite the ID, never the path.** Write "see `BR-014`" or "the product register" — never
a file path plus section. Everything referencing this register must survive the file
being reorganised, which is what makes reorganising it safe.

**The rationale never enters the register.** A row holds the statement, its ID, its
status, and a pointer to where it was decided. The *why* stays in the spec, ADR, or
interview answer it came from — those are already written and still readable. A row
growing past a couple of lines means reasoning has leaked in and belongs back at its
source.

**Superseding.** Never edit a row to mean something different. Set the old row's status
to `Superseded by <ID>` and add a new row with a new ID. The old row stays readable so
anything that cited it still resolves.

**Status** is `Active`, `Proposed`, or `Superseded by <ID>`.
**Source** cites where the rule was decided — a spec (`SPEC-ADOPT-003`), an ADR, or a
qualified interview question (`000/Q-SCOPE-02`).

## Business rules (`BR-`)

Domain policy — what the product permits, requires, or forbids. True about the domain
itself, regardless of how anything is built. State each so a single counter-example
falsifies it.

| ID | Rule | Status | Decided | Source |
|---|---|---|---|---|
| BR-001 | | | YYYY-MM-DD | |

<!-- WORKED EXAMPLE — delete once real rules exist.
| BR-001 | An animal in an active foster placement cannot enter the adoption queue. | Active | 2026-08-03 | SPEC-FOSTER-002 |
| BR-002 | Billing is charged in arrears: a base subscription plus per-adoption usage. | Active | 2026-08-03 | 000/Q-SCOPE-07 |
-->

## Product requirements (`PR-`)

Capabilities the product must provide, named against a persona from
`docs/PERSONAS.md`. The form is "the product must let ‹persona› do X".

| ID | Requirement | Persona | Status | Decided | Source |
|---|---|---|---|---|---|
| PR-001 | | | | YYYY-MM-DD | |

<!-- WORKED EXAMPLE — delete once real requirements exist.
| PR-001 | Must be able to see which animals still need attention this week without opening each record. | Shelter volunteer | Active | 2026-08-03 | SPEC-ACTIVITY-004 |
-->

## Non-functional requirements (`NFR-`)

Quality targets, each with a number. A requirement that must hold under *every* input
rather than on average is an **invariant** — record it in the next section instead.

| ID | Requirement | Target | Status | Decided | Source |
|---|---|---|---|---|---|
| NFR-001 | | | | YYYY-MM-DD | |

<!-- WORKED EXAMPLE — delete once real NFRs exist.
| NFR-001 | Animal list renders on a shelter's tablet over site wifi. | p95 under 2s at 500 animals | Active | 2026-08-03 | SPEC-ANIMAL-001 |
-->

## Invariants (`INV-`)

What must hold under **any** input, role, or request shape — not just the happy path.
Every invariant names the evidence that would prove it; one with no nameable evidence
is a business rule instead. Declared as rows because each is checked individually: an
isolation rule buried in a paragraph is invisible to anything that would verify it.

| ID | Must always hold | Evidence that proves it | Status | Decided | Source |
|---|---|---|---|---|---|
| INV-001 | | | | YYYY-MM-DD | |

<!-- WORKED EXAMPLE — delete once real invariants exist.
| INV-001 | No actor reads another organisation's records under any request shape. | Captured response + fresh-read storage snapshot | Active | 2026-08-03 | SPEC-AUTH-001 |
-->

## UX clauses (`UX-`)

Wording, tone, and presentation rules that apply across the product. Filed apart from
business rules because they are checked against the **rendered UI**, not against stored
data. Project-wide interface conventions live in `ai/STANDARDS/UI_STANDARD.md`; what
lands here is product-specific and clause-shaped.

| ID | Clause | Applies to | Status | Decided | Source |
|---|---|---|---|---|---|
| UX-001 | | | | YYYY-MM-DD | |

<!-- WORKED EXAMPLE — delete once real clauses exist.
| UX-001 | No wording implies the person failed when a search legitimately returns nothing. | Every empty state | Active | 2026-08-03 | SPEC-SEARCH-002 |
-->

## If this file ever gets too large

It is designed to stay one file. Entries are single statements, so even a mature
product's full set costs less to read than a couple of ADRs — and keeping them
together is the point: a contradiction between two rules is only visible when both
are on screen.

If a project genuinely outgrows it, move a whole section to a sibling file in this
directory (`BUSINESS_RULES.md`, `INVARIANTS.md`, …) and leave a one-line pointer under
the heading here. **IDs do not change and nothing else needs updating**, because
nothing cited a path. This is permitted, not scheduled — there is no threshold to
watch, and no reason to split a file that is merely long.
