# T34 — UX design mode: decompose vague design intent into an enforceable UX standard + journeys

> **DRAFT — opened 2026-07-28 from the T33 grill. Needs its own grilling session;
> nothing decided. This is the *design-time* front half of the UX-agent lifecycle whose
> *review-time* half is [T33](T33-independent-reviewer-agents.md).**

**Category:** Process + Module (new capability) · **Status:** In discussion (2026-07-28) — opened, not yet grilled · **Issue:** — · **Related:** T33 (review mode — same agent identity; shared feedback loop), T17 (feature-spec v2 — journeys are a shared artifact), T15 (inception interview — the machinery this extends), T26 (audience-first text), UI_STANDARD (the best-practice base this adapts)

**Problem / Origin:** ShelterSync's UX was never fully scoped up front. The T33 grill
established that its UX-conformance reviewer can only *enforce* a standard that *exists* —
and the root cause of the ShelterSync UX bugs (a whole demo-list of them) is that vague
design intent was never decomposed into an enforceable standard for anything to check
against. Chris (2026-07-28): the advisory agent's real leverage is **up front**, when
standards and features are being decided — *"It needs to help a user, who knows nothing
about UX and UI, turn vague themes and notions into a usable and elegant design which are
decomposed to standards, journeys, etc. The advisory agent enforces those concepts."*

So the UX agent is a **lifecycle with two modes, one identity**:
- **Design mode (this topic):** generative — partners with a non-designer to turn
  best-practice defaults + interview answers + vague design notions into concrete,
  enforceable artifacts (a project UX standard, personas, journeys). An interview, not a
  review.
- **Review mode (T33):** enforces exactly those artifacts against the running app.

**The enforcement target is a three-part stack** (T33.6): best-practice base (the generic
`UI_STANDARD.md`, already adaptable) + interview-derived clauses (`INTERVIEW_STANDARD.md`,
`QUESTION_BANK.md`) + decomposed design intent (the activity this topic designs).

**Grill agenda (seed — no presumed answers):**
- Where does design mode live — an extension of the inception/feature interview (T15/T17),
  a distinct command, or a phase of the same reviewer agent? Chris frames it as *one agent
  identity* wearing a design hat, because the agent that will enforce a standard is best
  placed to help author an *enforceable* one.
- How does a non-designer get guided from "warm, not clinical" to a testable clause without
  the agent imposing its own taste? What's the decomposition method?
- The **notes-to-clause feedback loop** must be written into both T33 and T34 or it falls
  in the crack between them: review-mode notes (clauseless friction) → recurring-note
  signal → new standard clause → sharper enforcement. This is *also* how "standards evolve
  as the project does" (Chris, 2026-07-27) — the loop, not a separate mechanism.
- Relationship to `docs/PERSONAS.md` and the journey registry (T33.5) as shared outputs.
- OQ-7 in SPEC-ADOPT-000 is a live worked example: a consumer app wanting *shared
  typography/iconography/radius, separate density and tone* from the admin standard — how
  design mode forks a standard per surface.

**Decision:** — (pending its own grilling session)

**Discussion notes:**
- Chris, 2026-07-28: split from T33 so T33 stays shippable (review mode enforces the
  best-practice base on day one, degrading gracefully) while this larger, vaguer
  design-partner problem gets the scrutiny it deserves. Same agent identity, recorded in
  both topics.
