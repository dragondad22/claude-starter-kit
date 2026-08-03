# T37 — Where do landed decisions live? T-topics vs ADRs + decision log

> **Decided 2026-08-03 (grilling session with Chris). Revises decided-and-released
> topics — T17.8, T33's reviewer inputs, and the shipped source-of-truth precedence.
> Closes the T-topic register: this is the last T-topic.**

**Category:** Structural (kit-wide convention; touches shipped precedence) · **Status:** **Decided (2026-08-03)** — grilled · **Issue:** #201 (grill) → implementation epic filed · **Related:** T7.4 (the routing rule being violated), T23.3/T36 (the retrofit that surfaced it), T32 (may create genuine architecture worth ADRs), T18 (`/conform` moves decision homes)

**Problem / Origin:** The T36 retrofit installed `docs/architecture/decisions/` and
`docs/decision-log.md` into a repo that already recorded 36 decisions as **T-topics** in
`docs/plans/`. Two homes for one job, one of them empty.

## Evidence gathered at opening

**1. The kit violates the routing rule it ships — and its own instance says so.** Both
`template/core/docs/plans/README.md` and this repo's adapted copy carry:

> Anti-catch-all routing rule — if it isn't structured discovery or a decision working
> doc, it does not go here: **A decision → `docs/decision-log.md` or an ADR**

Meanwhile every kit decision, with a filled `Decision:` block, lives in `docs/plans/`.

**2. The declared adaptation for that file is half-wrong.** `ADAPTATIONS.md` claims
`docs/plans/README.md` is adapted "because it holds the kit's decision records (T-topics),
so the shipped charter would be wrong about its own contents". The actual diff only
*removes* the interview-directory paragraph. The contradiction the row claims to fix is
still in the file. (Found while gathering this evidence; the row needs correcting whatever
T37 decides.)

**3. The shipped precedence order is vacuous in this repo.** `CLAUDE.md` ranks ADRs #2 and
the decision log #3, above feature specs — and both are empty here, so the top of the
source-of-truth hierarchy points at nothing.

**4. The reference surface is real.** 12 shipped files cite the ADR or decision-log homes,
including `ai/CHECKLISTS/coding.md`, `TASK_ISSUE_TEMPLATE.md`, `PAVED_ROAD.md`,
`/conform`, `/evergreen`, `GLOSSARY.md` and the shipped `CLAUDE.md`.

**5. The two models have different shapes.** The shipped model is **two-stage**: a working
doc in `docs/plans/` *precedes* the decision, which lands elsewhere as an ADR or log entry.
The kit's T-topic is **one artifact**: discovery, discussion and the landed `Decision:`
block accumulate in the same append-only file with a stable ID and supersede-in-place
stamps. That is a genuine design difference, not sloppiness — and it may be the better
model, or it may be the reason the routing rule exists.

## Open questions for the grill (seed — no presumed answers)

1. **What is a T-topic?** A decision working doc that happens to hold its outcome, or a
   decision record in its own right? Everything else follows from this.
2. If T-topics *are* decision records, does the **shipped** model change (port the
   one-artifact shape up), or is the kit a special case that declares an adaptation?
3. What happens to the **empty** `docs/architecture/decisions/` and `docs/decision-log.md`
   here — removed as declared adaptations, or used for a genuinely different class?
4. Is there a class of kit decision that *is* ADR-shaped — e.g. whatever T32 chooses for
   runtime and packaging — even if process decisions stay T-topics?
5. **Migration cost if ADRs win:** T-IDs are referenced across CI output, CHANGELOG
   entries, issue bodies, commit messages and the shipped standards. T-IDs are documented
   as permanent addresses.
6. **What does this make "same-role" mean for #202?** The retrofit needs to detect an
   existing decision home; the detector's definition depends on the answer here.

## The purpose this serves (Chris, 2026-08-03)

Recorded first, because it is the *why* the rest of this decision hangs on and it had
never been written down anywhere:

> The assessment step was always intended to be load-bearing. It's one of the primary
> purposes of the kit — to take the responses from user questions and turn them into the
> decisions, designs, and supporting documents and use that as the base and launching
> point of the application. It's not just about generating code, but about building a
> system a single developer can use to build an enterprise level application and all the
> supporting materials needed to plan and implement it.

The AI had framed the assessment step as "a risk to design against". That is wrong and is
corrected here: it is **the kit's central value proposition**. Interview answers →
decisions, designs and supporting documents → the launching point for the build. Every
artifact below exists to carry material across that step, and a gate on it is not
defensive plumbing — it is the kit doing its main job.

**Decision (2026-08-03):**

- **T37.1 — Proposals and registers are different things.** A **feature spec is a
  proposal**, consumed at implementation. **Registers** hold standing truth. A spec is
  authoritative about *what was proposed*, never about *what the system currently does*.
  Its value is communicating a feature's intent and requirements to someone who was not
  in the conversation — including a collaborator whose own AI generated it from the
  shipped templates. That is safe precisely because **a proposal carries no authority
  until it is consumed**.

- **T37.2 — The friction is the catchall, not the number of homes.** The shipped decision
  log states its own failure: *"When uncertain where a decision belongs, check existing
  patterns in both locations."* Guess-from-precedent is not a routing rule. It failed for
  lack of **internal structure**, not for being one file — so the fix is typed sections
  with stable ID prefixes, which answer "which home?" by construction.

- **T37.3 — Application-scope business rules and product requirements get a home they
  never had.** Today they are buried in whichever feature spec first mentioned them, or
  unwritten. This was the **silent** gap and it is worse than the catchall. One document
  with typed sections to start; a section splits into its own file when it earns one,
  **IDs unchanged** so every existing reference survives.

- **T37.4 — Add the two missing industry-standard forms.** **User stories** are absent
  from the entire shipped tree (verified: zero hits). **Acceptance criteria** exist in
  four places with no owner. Both become first-class and linked. Preference for
  recognisable industry forms is deliberate: a developer arriving from another org should
  recognise the artifacts, and a non-developer should be learning best practice by using
  them.

- **T37.5 — Source of truth becomes:** schema → **ADRs** → **registers** → journey
  registry → UAT docs → tracked issues. **Feature specs leave the precedence order**;
  they are inputs. A spec's status records whether it has been consumed, and an
  implemented spec points at where its content landed.

- **T37.6 — The assessment step gets an owning moment.** Implementing a spec includes
  **filing its content to the registers**, with two-way provenance (`BR-014` cites
  `SPEC-ADOPT-003`, and the spec points forward). Not because it is risky, but because it
  is the step the kit exists to perform — see *The purpose this serves* above. Without a
  gate, rules silently never land while the spec looks complete.

- **T37.7 — The T-topic register is closed.** T1–T37 remain valid, citable and
  permanently addressed; the register is stamped historical and takes no new entries.
  From here a kit decision produces a working doc in `docs/plans/` plus an **ADR** or a
  register entry — the kit uses the model it ships (T36). **This is the last T-topic.**

- **T37.8 — Revisions this forces, all to decided-and-released material:** T17.8's
  same-PR spec keep-current rule (wrong under this model — registers get kept current,
  not proposals); T33's reviewer inputs (read the registers, not a possibly-superseded
  proposal — strictly more correct); the shipped precedence order; and the shipped
  `docs/plans/` routing rule, which turns out to have been **right all along** while the
  kit violated it.

- **T37.9 — #202 gets its missing definition.** "An existing same-role decision home" now
  means: a surface holding landed architectural decisions (ADR-shaped) or a typed
  decision/requirement register. The retrofit's detector has something concrete to look
  for.

**Evidence that the model is already proven in miniature:** the review module's
`JOURNEY_REGISTRY.md` is *"the durable list… the record of which ones must keep working"*
and cross-references `SPEC-<DOMAIN>-NNN` **"when a spec exists"**. Register is truth, spec
is an optional input. The pattern was built for journeys and never named.

## Discussion notes

- 2026-08-03: opened from #184. Chris chose to take this before #202 on the grounds that
  the answer shapes what the retrofit should detect. It did.
- 2026-08-03 (grill Q1): the AI offered three options framed as "T-topic vs ADR". **Chris
  rejected the framing**: ADRs are specific to architecture, which is why a decision log
  exists at all, and *"decision_log has become a catchall for anything not architecture
  and this is where the friction lives."* The question was not which home but what
  taxonomy — and the answer should use forms a developer already recognises.
- 2026-08-03 (grill Q2): the AI implied BR/NFR are inherently spec-scoped. **Chris
  corrected it** — true when defining a feature, false for the application as a whole.
  That correction exposed the silent gap in T37.3, which is larger than the catchall the
  topic was opened about.
- 2026-08-03: ShelterSync's decision log was cited as a mature example covering all the
  decision kinds. Not readable from this repo; if its category list is captured later it
  is the best available evidence for validating the register's sections.
- 2026-08-03: the AI called the assessment step "a risk to design against". Corrected by
  Chris to the kit's primary purpose — see *The purpose this serves*. Worth elevating
  beyond this topic: it is arguably the kit's mission statement and lives nowhere else.
