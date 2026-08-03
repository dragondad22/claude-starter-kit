*Generic standard from the Claude starter kit — adapt to this project's stack. Replace `{{TOKENS}}`; see `bootstrap/PLACEHOLDERS.md`.*
*Optional — installed with the review module. Keep only if this project has a driveable UI you want reviewed independently.*

# Independent Review Standard

Last Updated: 2026-08-03

## Purpose

Every other verification surface in this kit is run by the agent that did the
work, scoped to the change it just made (the test suite, `/qa` over the diff,
the per-item acceptance doc, the Impact-Analysis checkbox in
`ai/CHECKLISTS/coding.md`). None of them drive the running application, none are
scoped to flows the diff *didn't* touch, and none are independent of the author.

This standard governs a set of **independent reviewer agents** that close exactly
that gap: they drive the running app locally as real personas, verify that values
actually persist, and re-check existing flows after a change — so a break in an
*untouched* flow, caused by a change to something *shared*, is caught by
automation instead of by a user weeks later.

This file is the single home for the *why*. The reviewer agents, the journey
registry, and the run commands install with this module and point back here.

## When it runs

- **Locally, on demand** — never in CI, to keep the cost off shared minutes.
- **Strongly suggested after a shared-surface change** — a change to an
  enum/lookup vocabulary, a database column/constraint, a seed/default, a shared
  type/helper, or a migration. "Large" is *what a change can reach*, not how many
  lines it touched: a one-line vocabulary edit can break every form that consumes
  it. The suggestion is an offer, never an automatic run.
- **Never against production** — see *Environment & safety*.

## The reviewers and their authority

Three agents. Which authority an agent holds follows from whether its findings are
**objectively falsifiable** — invariance is a property of the agent, not a
blanket rule.

| Agent | Asks | Observes through | Authority |
|---|---|---|---|
| **UAT persona driver** | Can this persona complete this journey, and do the invariants hold? | the UI | **verdict** |
| **Data-integrity verifier** | Is the stored value what the persona meant to save? | a channel the UI cannot influence (API read / data query) | **verdict** |
| **UX evaluator** | Would this persona understand what to do here? | the UI | **advisory** |

- A **verdict** agent judges against things that are true-or-false with evidence,
  so its findings can gate. A **verdict is only as good as its evidence** — see
  *Evidence*.
- An **advisory** agent's findings are judgments; it cites a written clause but
  never blocks. Advisory output must never launder itself into work with no human
  in between (see *How findings exit*).

### The verifier never trusts the UI

The driver can only see what the UI shows it — and the UI is the thing under
suspicion. The dangerous form of a persistence bug is the one where the screen
shows a cheerful "saved" over a value the backend cannot match. The verifier
therefore consumes the driver's **action log** ("selected the option labelled
`Spayed/neutered` on record 41") — *never the driver's own pass/fail* — and
independently asserts what landed in storage. If it has no storage-independent
read channel, it reports `BLOCKED` and states the human action required; it never
falls back to believing the UI, because that erases the only reason it exists.

## Independence: what the driver may know

A reviewer that knows *where the change was* stops sweeping and starts
spot-checking the diff — and the bugs that matter most live in the flows the diff
never touched. So the rule is:

> **A reviewer may read what should be *true*. It may not read how something was
> *done*.**

| May read | Must not read |
|---|---|
| The persona | The diff |
| The journey's **goal** and done-condition | The implementation conversation |
| Business rules and edge cases | The journey's numbered **steps** |
| The invariant set (below) | The source under test |

A business rule stated as a procedure ("confirm twice before deleting") is still a
statement of what must be true, and is legitimate reviewer input — the test is
"can the persona do it the way specified?"

**Enforcement.** Selecting *which* journeys to run needs the diff — so that
scoping step is done by a separate scoper that hands the driver only journey
identifiers, never the diff or the reason those journeys were chosen. Reviewer
agents are given no version-control tooling and no diff in their brief. This is a
firewall of *what is loaded*, not a promise the agent makes about its own
attention — treat it as partial and design briefs accordingly. A reviewer must not
be able to tell a post-change re-check from a first-time run.

## Invariants: the failures no document predicted

Acceptance criteria catch what someone thought to write down. The costly bugs are
the ones nobody wrote a criterion for. So the driver checks a fixed set of
**invariants** on every flow it walks, independent of any document:

- **Round-trip** — every value the persona saves survives a fresh read (reload or
  re-navigate — not the optimistic UI that just claimed success).
- **Offered means accepted** — every option a control offers can actually be
  selected and saved. *(This is the class of the originating incident, stated
  generally.)*
- **No silent failure** — no unhandled 4xx/5xx and no uncaught client error on a
  path the persona is expected to complete.
- **No dead end** — every flow the persona can start can be completed or
  deliberately abandoned.

Rules:

- **An invariant failure is a failure even when every criterion passes**, and even
  when a document says the behaviour is fine. A criterion can be wrong; a broken
  save cannot be right. Waiving an invariant for a specific flow is an architecture
  decision (record it), not a silent skip.
- **Every invariant names the evidence that proves it** (a fresh-read snapshot, a
  storage read, a captured response). If you cannot name the artefact, it is not an
  invariant — it is an advisory note.
- **Feature-specific invariants are declared in the feature's own spec**, not here
  — e.g. an isolation rule like "no actor reads another tenant's data under any
  request shape". The spec template declares them as `INV-n` rows, each naming the
  evidence that proves it (`docs/specs/README.md`), so they arrive checkable rather
  than buried in an NFR paragraph. This universal set is the floor every project
  gets for free.
- *Offered means accepted* runs cheaply by default (the option a persona would
  naturally pick) and exhaustively when the change touched a shared vocabulary.

## Evidence

**No evidence, no verdict.** Every verdict finding cites a concrete artefact — a
snapshot, a captured network response, or a storage read. A claim that "the save
worked" with nothing cited is a note, not a verdict; this is the guard against a
reviewer that reports success it never actually observed. Store artefacts under a
dated, per-run directory in `testing-reports/` (local only, never committed), the
same convention the diagnostic bundle uses
(`ai/TEMPLATES/DIAGNOSTIC_BUNDLE_TEMPLATE.md`).

## How findings exit

| Class | Exit |
|---|---|
| **Verdict** (driver, verifier — falsifiable, evidence-cited) | **auto-filed** as a bug, per `ai/STANDARDS/GITHUB_ISSUES.md` |
| **Advisory** (UX evaluator — cites a UX clause) | **drafted** for a human to promote — never auto-filed |
| **Note** (real friction that violates no written clause) | recorded in the run summary only — never filed |

- Filing a bug is non-destructive, so auto-filing verdict findings is the default
  for a solo maintainer with no triage layer. A single project setting may
  downgrade verdicts to drafts where a team wants a triage gate.
- **De-duplicate** on (journey + invariant/criterion + surface): a failure that
  recurs every run updates or references its existing issue rather than opening a
  new one each time.
- Every run ends with **one human-readable summary** — filed, drafted, and noted —
  so a run reads at a glance, not as a scatter of issues.

De-duplication and the summary are both derived from the run journal — one
append-only JSONL record per finding, objective facts and evidence pointers only:
`ai/STANDARDS/REVIEW_RUN_JOURNAL.md`. Filing checks prior journals + open issues for
the same key before opening anything new.

### "How do I…?" is a design finding, not a note

A persona (or a human tester) needing to be *told how* to do something is a defect
report against the flow's design. The UX evaluator routes it per the "how do
I…?" rule in `ai/STANDARDS/UI_STANDARD.md`, not as help text.

## The UX evaluator enforces written clauses

The advisory agent is not a taste engine. Its checklist is the project's own UX and
documentation standards applied to the running app — audience-first copy, no
internal identifiers shown to users, humanised codes, present loading/empty/error
states, and the rest of `ai/STANDARDS/UI_STANDARD.md` — plus any `UX-n` clause the
feature's own spec declares, which is citable on the same footing as a standard's.
**Every advisory finding cites the clause it violates**, so even advisory output is
falsifiable in its basis (advisory only in its authority). It **never proposes features**: the absence
of a capability the product never claimed is out of scope — that belongs to
feature intake, not a review. Friction that violates no existing clause becomes a
note; a *recurring* note is evidence the UX standard is missing a clause.

## Environment & safety

The reviewers **mutate** — they create, edit, and cancel. That makes the target
environment a safety decision, not a footnote.

- **Never production.** A reviewer refuses to start unless configuration asserts a
  non-production target (`{{REVIEW_BASE_URL}}`) and aborts on anything resembling a
  production host. Because the run is human-invoked, this is a configuration
  assertion plus a loud refusal, not a hard interlock — point it somewhere safe on
  purpose.
- **Seeded and resettable.** The reviewer drives a seeded instance (`{{DEV_COMMAND}}`
  against review data) rich enough to reach the flows under test. It never resets
  the environment itself (that is destructive); it requires a known starting state
  and reports a dirty one. Seed realism follows the Data Realism guidance in
  `ai/STANDARDS/TESTING_STANDARD.md`.
- **No real credentials.** Persona logins come from local configuration, never
  committed.
- The round-trip invariant needs no pre-seeded "expected" value — it checks that
  *what the persona just entered* is what persisted — so seed data only has to be
  enough to reach the forms.

## When a run cannot complete

Distinguish, on one objective line — *did the check actually run?*

- **The check could not run** (the app wouldn't start, the driver crashed, a
  timeout) → retry once from a fresh start; if it still cannot run, report
  `BLOCKED` with the exact human action required. A retry re-runs the *check*, not
  any product work.
- **The check ran and found a failure** → that is a finding. File or note it per
  *How findings exit*. It is never retried away.

## Driving and codifying (overview)

The reviewer's judgement is expressed independently of the tool that touches the
app; each surface plugs in a **driver** behind a small contract, and a driver is
either *interactive* (an agent steers it live — required for exploratory
discovery) or *playback* (a committed script — regression only). A confirmed flow
is banked as a committed regression test through the project's own end-to-end
runner (`{{E2E_COMMAND}}`), so the expensive naïve pass is paid once and every
re-run after it is cheap and deterministic. The reviewer emits a **codified-spec
proposal** — *data, not test code* (`ai/TEMPLATES/CODIFIED_SPEC_PROPOSAL_TEMPLATE.md`)
— and a normal coding step lands it, so the agent that *judged* a flow never authors
the regression that will *re-judge* it. The driver contract, the reviewer agents, the
journey registry, and the run journal (`ai/STANDARDS/REVIEW_RUN_JOURNAL.md`) install
with this module; their mechanics are documented where they ship.
