# specs — feature specs

Journey-first feature specifications: one document per feature
(`SPEC-<DOMAIN>-NNN`, template: `ai/TEMPLATES/FEATURE_SPEC_TEMPLATE.md`), two
layers in one file, ordered by audience:

- **Journey layer** (top) — persona (by name, from `docs/PERSONAS.md`), goal,
  plain-language steps, and a simple flow diagram of **user actions — never
  table names**. Written so a non-technical stakeholder can read it and confirm
  "yes, that's what should happen"; exportable/shareable standalone.
- **Technical layer** — feature decisions, preconditions, data touchpoints,
  invariants, business rules, NFRs, UX clauses, edge cases — for the AI,
  developers, UAT, and independent reviewers.

Specs are a generated founding artifact of a feature interview — derived from
its `Final:` fields with `Source:` Q-ID provenance (see
`ai/STANDARDS/INTERVIEW_STANDARD.md`).

## A spec is a proposal

A spec is authoritative about what was **proposed** for a feature. It is never
authoritative about what the product currently does — that is the register's job.

**A proposal carries no authority until it is consumed.** At implementation, the
assessor files the spec's content to its permanent homes: business rules, stories
and their acceptance criteria, invariants, NFRs and UX clauses to
`docs/registers/`, architecture to ADRs. The spec's `Landed in` field records
where each part went, and its status becomes **Consumed**.

Two things follow, and both are the point rather than side effects:

- **A spec is safe to accept from anyone.** A collaborator, or a collaborator's AI
  working from these templates, can hand over a spec without it silently binding
  the product — nothing in it takes effect until someone with the architectural
  context assesses it and files it.
- **A consumed spec is not kept current.** It records what was agreed at a moment
  in time. Editing it to match later behavior destroys the only thing it was good
  for and produces a second, weaker copy of the register. Behavior changes update
  the **register rows**, not the spec that first proposed them.

Because specs are inputs rather than standing truth, they sit **outside** the
source-of-truth precedence order — see `CLAUDE.md`. Where a spec and a register
row disagree about what the product does, the register is right and the
disagreement means the spec was never fully consumed.

## Self-contained: what a spec states, and what it must not

A spec is a **complete, separate, environment-agnostic** document. It states
*what* must be true, and it **refers to** existing ADRs and decisions by ID. It
never **prescribes** an ADR, an architecture, a physical data model, or a
register entry.

Two independent reasons:

- **Numbering drifts.** ADR and decision IDs are assigned as they are made, and
  features land in parallel — so a spec that prescribes "ADR-014" is wrong the
  moment another feature claims that number, and a spec that embeds an
  architecture goes stale the moment a neighbouring feature moves it.
- **Separation of roles.** The spec author states *what* with the context they
  have. The **assessor** — whoever reads the spec at development time, holding
  the architectural context — decides *how*: the ADRs to raise, the physical
  model, the bindings. Asking the spec author to decide *how* asks for a
  judgment they are not positioned to make.

So a spec **holds** journeys, personas (by reference), descriptions, feature
decisions with their reasoning, business rules, NFRs, invariants, UX clauses,
and edge cases; and it **excludes** architecture decisions, physical schema, and
the conceptual→physical binding. The binding in particular is a
development-assessment artifact and is deliberately not a spec section — where
one is needed and missing, that is a finding against the assessment, not a gap
in the spec.

A choice the spec author cannot make lands in **Open questions**, which is how a
spec hands work to the assessor without pretending to have done it.

## Declared, not buried

Two kinds of content are **declared as rows or clauses** rather than written
into a paragraph, because a downstream consumer has to act on each one
individually:

- **Invariants (`INV-n`)** — what must hold under *any* input, role, or request
  shape. Every invariant names the evidence that would prove it; one with no
  nameable evidence is a business rule instead. An organisation-isolation rule
  written into an NFR paragraph is invisible to anything that would check it.
- **UX clauses (`UX-n`)** — feature-specific wording, tone, and presentation
  rules. Filed separately from business rules because they are checked against
  the running UI rather than against stored data; a rule like "no wording
  implies the persona failed" is a UX-conformance check wearing a business rule's
  clothes.

Project-wide UX rules stay in `ai/STANDARDS/UI_STANDARD.md` — a spec carries only
what is specific to its feature.

If the **review module** is installed, its independent reviewer agents consume
both: the UAT driver is handed the feature's invariants and checks them
alongside its universal set, and the UX evaluator may cite a spec's `UX-n`
clause the same way it cites a standard's
(`ai/STANDARDS/INDEPENDENT_REVIEW_STANDARD.md`).

## Business rules state requirements

A business rule states the **requirement**, not the implementation — though the
requirement may itself *be* a procedure ("confirm twice before deleting"), which
is still a statement of what must be true. Either way the testable question is
"can we do it the way specified?"

## Notation

Markdown is the default, and a spec is not limited to one flowchart. Use the
notation that fits the shape being described — a state diagram for a lifecycle,
an entity-relationship view for how things relate, a sequence diagram for a
handoff across actors, a table where the content is tabular. Where markdown
genuinely cannot express something, use a representation that can and reference
it from the spec.

## Quality mechanisms

Why v1 "workflow docs" rotted, designed against:

- **Nothing here is asked to stay current.** Rot was the symptom of one document
  trying to be both the proposal and the record of the system. Split them and it
  cannot happen: what must stay true is filed to the register at consumption and
  kept current *there*, while the spec is dated by design and honest about it. A
  document that never claimed to be current cannot go stale.
- **Consumption is a gate, not a habit.** A spec reaching **Consumed** with an
  empty `Landed in` is the failure this design has to catch — it means the
  content was built but never filed, which looks identical to done.
- **UAT traceability:** acceptance criteria cite journey step numbers and
  edge-case row IDs, so a spec that misses reality fails visibly at UAT
  instead of silently.
- **Initial quality:** the feature interview stress-tests scenarios (invent
  edge cases during the interview, don't just transcribe answers).
