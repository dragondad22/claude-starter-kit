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
`ai/STANDARDS/INTERVIEW_STANDARD.md`). They outrank UAT docs in the
source-of-truth precedence when they exist.

## Self-contained: what a spec states, and what it must not

A spec is a **complete, separate, environment-agnostic** document. It states
*what* must be true, and it **refers to** existing ADRs and decisions by ID. It
never **prescribes** an ADR, an architecture, a physical data model, or a
decision-log entry.

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

- **Keep-current:** spec updates ride the documentation standard's same-PR
  rule — behavior changes and their spec land together.
- **UAT traceability:** UAT acceptance criteria cite journey step numbers and
  edge-case row IDs, so a spec that misses reality fails visibly at UAT
  instead of silently.
- **Initial quality:** the feature interview stress-tests scenarios (invent
  edge cases during the interview, don't just transcribe answers).
