*Generic template from the Claude starter kit — installed with the review module. The shape a reviewer emits for a clean flow, and a coding step lands as a committed regression test.*

# Codified-spec proposal: <JRN-DOMAIN-NNN — journey title>

The ratchet in one artifact: a reviewer that just drove a flow **cleanly** emits this —
*data, not test code*. A normal coding step (under `ai/CHECKLISTS/coding.md`, reviewed
like any change) turns it into a committed regression test in the project's own runner.

**Why the split:** the reviewer stays read-only and independent — the agent that *judged*
the flow does not also *author* the regression that will re-judge it (a subtly wrong
self-authored assertion would become a permanent green lie). And the naïve, expensive
agent pass is paid **once**: after it is banked here and landed, re-running the flow is
deterministic test code that costs no agent tokens.

---

**Journey:** `JRN-<DOMAIN>-NNN` — <title>  ·  **Persona:** <name from `docs/PERSONAS.md`>
**Surface:** <web | mobile | api | …>  ·  **Driver:** <the interactive driver used>
**Run:** <run id from the journal>

## Preconditions

- Non-production target, seeded state (`{{REVIEW_BASE_URL}}` / `{{DEV_COMMAND}}`).
- <any starting data the flow assumes — an existing record to edit, a logged-in persona, …>

## Actions as executed

The real actions the driver took, addressed the way a **user** perceives the controls
(visible label / accessible name), never by internal identifier or coordinate. This is
the driver's action log, verbatim enough to replay.

1. <navigate to … >
2. <act: entered `<value>` in the field labelled `<label>`>
3. <act: selected the option labelled `<option>`>
4. <…>

## Assertions to bank

What the codified test must check — the invariants that held and any done-condition:

- **Round-trip:** after a fresh reload, `<field>` still reads `<value>`.
- **Offered means accepted:** the option `<option>` saved without error.
- **Storage (from the verifier):** `<entity.field>` in storage equals `<value>` — the
  intent-vs-storage check, asserted through the UI-independent channel, not the screen.
- **Done-condition:** <the journey's stated success condition, if the journey is `verified`>.

## Evidence captured

- <path to snapshot / response artifact under `testing-reports/…`>

## Landing notes (for the coding step)

- Target runner: `{{E2E_COMMAND}}` (the playback half of the driver seam).
- Suggested spec path: <e.g. `e2e/<domain>-<slug>.spec.*`> — record it back in the
  journey registry's **Codified spec** column once landed (keep-current).
- Do not weaken the storage assertion into a UI check when translating — the
  intent-vs-storage comparison is the point.
