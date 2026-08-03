Run an independent review: drive the running app as real personas, verify values persist, and check flows a diff didn't touch. Full doctrine: `ai/STANDARDS/INDEPENDENT_REVIEW_STANDARD.md`. Driver wiring: `ai/STANDARDS/REVIEW_DRIVER_CONTRACT.md`. Journeys: `docs/uat/JOURNEY_REGISTRY.md`.

Modes (argument after `/review`):
- *(none)* → **blast-radius** when there are uncommitted/branch changes, else ask which tier.
- `critical` → every journey marked `critical`.
- `full` → every journey in the registry.
- `discover <area>` → propose new registry journeys for an area (does not judge outcomes).

## 1. Safety gate (always first)

- Confirm the target is **non-production**: `{{REVIEW_BASE_URL}}` must be set and must not
  look like a production host. If it is unset or production-like, **stop** — do not run.
- Ensure a seeded instance is reachable (start it with `{{DEV_COMMAND}}` against review
  data if needed). The reviewers mutate data; never point them at anything real.

## 2. Scope the run — YOU read the diff, the agents never do

This step needs the diff; the reviewer agents must not see it (that would turn a naïve
sweep into a spot-check). So *you* (this command) select the journeys, and pass the
agents only journey briefs — never the diff, file paths, or change description.

Select journey IDs from `docs/uat/JOURNEY_REGISTRY.md` by tier:

- **blast-radius** (default for a change): from `git diff` decide what the change
  *touched* — especially a **shared surface** (an enum/lookup vocabulary, a DB
  column/constraint, a seed/default, a shared type/helper, or a migration; the
  Impact-Analysis categories in `ai/CHECKLISTS/coding.md`). Select every journey whose
  **Entities / vocabularies touched** intersects that set — **including journeys whose
  own screens did not change.** That intersection is the whole point: it reaches the
  untouched flow a shared-vocabulary change can break.
- **touched-by-diff**: journeys whose own screens/files changed. Narrowest.
- **critical**: all `critical` rows, ignoring the diff.
- **full**: all rows.

If the registry is sparse, say so — an undeclared journey can't be blast-radius-targeted
(it can still be run in a `critical`/`full` tier, on invariants alone).

## 3. Drive each selected journey

For each journey, build a **brief** from the registry + its feature spec: the persona
(by name, from `docs/PERSONAS.md`), the goal and done-condition, business rules, edge
cases, and the invariant set. **Never put the diff or change description in the brief.**

- Invoke **`review-uat-driver`** with the brief → it walks the flow, checks the
  done-condition + invariants, and returns an **action log** + a codified-spec proposal.
- Invoke **`review-data-verifier`** with the driver's **action log** (not its verdict) →
  it asserts each mutation against storage independently.
- For user-facing flows, invoke **`review-ux-conformance`** with the brief → clause-cited
  advisory findings + notes.

Run the driver's *offered-means-accepted* invariant **exhaustively** when the change
touched a shared vocabulary (that is the case this run exists for); cheaply otherwise.

## 4. Route the findings

Per `ai/STANDARDS/INDEPENDENT_REVIEW_STANDARD.md` → *How findings exit*:

- **Verdict** findings (driver, verifier — evidence-cited) → **file** as bugs per
  `ai/STANDARDS/GITHUB_ISSUES.md`. **De-duplicate** on (journey + invariant/criterion +
  surface): update or reference an existing issue instead of opening a new one each run.
  (A project may choose to draft instead of file — respect that setting.)
- **Advisory** findings (UX, clause-cited) → **draft** for a human to promote; never file.
- **Notes** (no clause) → summary only; never filed.

Store evidence under a dated, per-run directory in `testing-reports/` (local only, never
committed).

## 5. One summary

End with a single human-readable summary: tier and journeys run, pass/fail/blocked per
journey, what was filed, what was drafted, what was noted, and any `BLOCKED` with the
exact human action needed. A codified-spec proposal from a clean flow is offered for a
normal coding step to land as a committed regression test — you do not write test code
here.

## discover mode

`/review discover <area>`: turn `review-uat-driver` loose in its discovery capability to
find flows that exist in `<area>` and propose registry rows — persona, starting point,
entities touched — **but never a done-condition** (observed behaviour is not an outcome).
Output the proposals for a human to merge into `docs/uat/JOURNEY_REGISTRY.md`; do not
write the registry yourself. Requires an `interactive` driver (see the driver contract).
