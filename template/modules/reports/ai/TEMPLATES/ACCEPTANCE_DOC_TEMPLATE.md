*Generic template from the Claude starter kit — adapt to this project. Replace `{{TOKENS}}`; see `bootstrap/PLACEHOLDERS.md`.*

# Acceptance Doc: <{{WORK_ITEM_PREFIX}}-NNN> — <feature / change title>

<!--
WHAT: the agent-facing acceptance spec for one work item — the criteria the
change must meet, and their recorded outcomes. Required by the task-issue
completion gate ("Docs to Update"); consumed by /qa; governed by
ai/STANDARDS/UAT_SOURCE_OF_TRUTH.md (source precedence, scenario minimums,
evidence rules).

WHERE: docs/uat/UAT_{{WORK_ITEM_PREFIX}}-NNN.md — this file IS the UAT spec at
the top of the document-precedence order for its work item.

NOT THIS FILE: the human-facing beta guide (goals-not-steps hand-off for beta
testers) is a separate artifact — ai/TEMPLATES/BETA_GUIDE_TEMPLATE.md, in
docs/uat/beta/. Never blend the two audiences in one document.

RESULTS: success is silent (exit code + one summary line). A failed gate
produces a diagnostic bundle (ai/TEMPLATES/DIAGNOSTIC_BUNDLE_TEMPLATE.md) —
link it from the outcome column; do not paste failure detail here.
-->

## Sources

Precedence per `ai/STANDARDS/UAT_SOURCE_OF_TRUTH.md` — cite what governs this run:

| Source | Ref |
|---|---|
| Feature spec | <SPEC-DOMAIN-NNN, `docs/specs/`> |
| Implementation plan / work item | <{{WORK_ITEM_PREFIX}}-NNN link> |
| ADRs / register | <ADR-NNN, BR-nnn — or "none"> |

## Acceptance criteria

Criteria are explicit, written, and traceable. **Never invent criteria mid-run** —
a spec or register that misses reality must fail visibly here, not get patched
silently from memory.

**Durable criteria live in the product register** (`AC-n`, against the story they
close) and are cited here by ID, not restated — the criterion is standing truth,
the outcome below is this run's record of it. Criteria specific to *this change*
("the migration backfills existing rows") have no register entry and are written
out in full here, citing the work item.

| # | Criterion | Ref | Outcome (pass / fail / blocked) | Evidence |
|---|---|---|---|---|
| 1 | <cited — leave blank, the register holds the text> | <AC-007> | <pass> | <artifact path / API snippet ref> |
| 2 | <change-specific: what must observably happen this time> | <{{WORK_ITEM_PREFIX}}-NNN> | <…> | <…> |

<!-- A durable criterion that is missing from the register is a finding: file it
     to the register rather than writing it here, or the next run re-invents it. -->

## Register coverage

- Stories this change serves: <US-n, … — or "none recorded">
- Register criteria left unverified by this run, and why: <AC-n + reason, or "none">
- Durable criteria discovered during the run and filed to the register: <AC-n, or "none">

## Edge-case matrix

Minimum set per the standard: 3+ edge cases (invalid input, empty state,
boundary value), role/permission boundary (if applicable), navigation
resilience (refresh / back), tenant isolation (if applicable), responsive
viewports for web (375x812 / 768x1024 / 1280x800).

| # | Case | Input / precondition | Expected | Outcome | Evidence |
|---|---|---|---|---|---|
| EC-1 | <invalid input> | <…> | <…> | <…> | <…> |

## UX and accessibility critique

- Clarity: <labels, helper text, error messages actionable?>
- Friction: <unnecessary steps, ambiguous controls, confusing defaults?>
- Visual integrity: <spacing/alignment/overflow at the required viewports?>
- Accessibility basics: <keyboard navigation, visible focus, control labels, contrast check?>

## Automation

- E2E smoke: <`{{E2E_COMMAND}}` — exit code / run link>; failure artifacts
  (screenshot / trace / video) retained and linked above.

## Test integrity audit (green-but-lying check)

The suite is green — audit whether it's telling the truth (rule:
`ai/STANDARDS/TESTING_STANDARD.md` § Green-run audit):

- Skipped/disabled tests touching this work item, and why: <list, or "none">
- Tests that cannot fail (no meaningful assertion / asserting on mocks of
  mocks): <findings, or "none observed">
- Suite-name vs behavior drift in the touched areas: <findings, or "none">

## Data realism review

- Where do this run's mocks/fixtures diverge from production-shaped data
  (shapes, volumes, states) enough to mask a real failure? <findings, or
  "fixtures judged representative — basis: …">

## Blockers, risks, issues

- <filed issues with links; risks accepted and by whom; BLOCKED items with the
  exact human action required — or "none">

## Self-correction log

| When | Planned path blocked | Adaptation taken |
|---|---|---|
| <…> | <…> | <alternate path / role / source reconciliation> |

## Completion gate

Per the standard — this doc is complete only when:

- [ ] Every acceptance criterion has a recorded outcome
- [ ] The edge-case matrix is fully populated
- [ ] The UX/accessibility critique is complete
- [ ] Blockers, risks, and issues are explicitly documented
- [ ] The E2E smoke ran with failure artifacts retained (or the non-web equivalent)
- [ ] Test integrity audit and data realism review recorded (findings → tracked issues)
