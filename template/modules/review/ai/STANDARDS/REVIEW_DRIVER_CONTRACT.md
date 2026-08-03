*Generic standard from the Claude starter kit — adapt to this project's stack. Replace `{{TOKENS}}`; see `bootstrap/PLACEHOLDERS.md`.*
*Optional — installed with the review module. The seam that lets the reviewer agents drive any surface without being coupled to one tool.*

# Review Driver Contract

Last Updated: 2026-08-03

## Why this exists

The reviewer agents (`ai/STANDARDS/INDEPENDENT_REVIEW_STANDARD.md`) express their
judgement independently of whatever actually touches the app — *walk this journey as
this persona, act, assert the round-trip, cite evidence*. **How** those actions reach
the running app is a **driver**: a small, per-surface adapter this project provides.
A web surface drives through a browser automation tool; a native mobile surface drives
through a device/emulator tool; an API-only surface drives through its client. The
reviewer never names a tool — it calls the verbs below, and the driver you wire in
carries them out.

The kit ships this contract and *names* paved-road drivers per surface (below). It
**mandates none**. If a tool doesn't meet the contract, don't use it.

## Capability flag: interactive vs playback

Every driver declares one capability, and it changes what the reviewer can do with it:

- **`interactive`** — an agent steers it live, deciding the next action from what it
  just observed. **Required for discovery and the naïve persona drive** (the reviewer
  can't explore a flow it can only replay).
- **`playback`** — it runs a pre-written script the same way every time. **Regression
  only** — it re-runs a flow already discovered and codified; it cannot discover.

A surface may wire in *both* — an interactive driver for discovery, a playback runner
for the banked regression suite. That is the normal shape (see the ratchet in the
review standard): pay for the interactive naïve pass once, re-run the playback suite
for free.

## The verbs a driver must provide

A driver is complete when it can do all five. Inputs/outputs are described by intent,
not by signature — implement them in whatever form your tool and language use.

| Verb | Must do | Notes |
|---|---|---|
| **navigate** | Put the app into a named starting state — a route, screen, or entry point named the way the *journey* names it, not by internal identifier. | Playback drivers may only navigate to states their script defines. |
| **act** | Perform one user action — tap/click, type, select an option, submit — against an element addressed the way a **user** perceives it (its visible label or accessible name), never a raw coordinate where an addressable handle exists. | Coordinate fallback is allowed only when no stable handle exists (see *Addressing*), and must be recorded as such in the action log. |
| **snapshot** | Capture the current *observable* UI state — a structured representation (accessibility/semantics tree preferred) **and** a visual artifact — as evidence. | The structured form is what the reviewer reasons over; the image is human evidence. |
| **read-back** | Re-observe a value **after a fresh load** (reload / re-navigate), not from the optimistic view that just claimed success. | This is the UI half of the round-trip invariant. It is *not* the verifier's storage read — see below. |
| **emit-evidence** | Write each snapshot/artifact to the run's evidence directory under `testing-reports/` and return a path the reviewer can cite. | Local only, never committed (the diagnostic-bundle convention). |

Every action a driver performs is recorded in an **action log** in the reviewer's own
words — *"selected the option labelled `Spayed/neutered`"*, not *"clicked element #3"*
— because that log is what the data-integrity verifier asserts against, and "the third
option" is not assertable.

## Addressing elements

- Address by what a user perceives: visible text, accessible name, role. This keeps the
  driver aligned with what a real person would find, and it is what makes a flow
  re-findable when the layout shifts.
- A **coordinate tap is a last resort**, allowed only where a surface exposes no stable
  handle — and it is logged as a coordinate action so the gap is visible, not hidden.
  On canvas-rendered surfaces (e.g. Flutter) a rich semantics tree removes the need for
  coordinates; exposing that tree is the same work as screen-reader accessibility
  (`ai/STANDARDS/UI_STANDARD.md`), so the accessibility the product owes its users is
  also what makes it cleanly driveable.

## The verifier's storage read is NOT a driver verb

`read-back` re-reads the **UI**. The data-integrity verifier asserts against
**storage** through a channel the UI cannot influence — an API read or a data query —
so that a screen which lies about having saved cannot also certify the lie. That
channel is configured separately from the driver (an API base or query path, against
the same non-production target as the UI — `{{REVIEW_BASE_URL}}`). If a surface exposes
no independent read channel, the verifier reports `BLOCKED`; it never falls back to the
driver's UI observation, because that erases the independence that is its whole purpose.

## Wiring a driver into this project

- **Target:** the driver and the storage-read channel both point at the seeded,
  non-production instance (`{{DEV_COMMAND}}` against review data, reachable at
  `{{REVIEW_BASE_URL}}`). The reviewer refuses to run against anything resembling
  production.
- **Regression runner:** banked flows re-run through the project's own end-to-end
  runner (`{{E2E_COMMAND}}`) — the playback half of the seam.
- **Declare** each surface's driver and its capability (`interactive` / `playback`)
  where this project keeps its review configuration, so a run knows what it can do on
  each surface.

## Paved-road drivers (recommendations, not mandates)

| Surface | Interactive (discovery) | Playback (regression) |
|---|---|---|
| Web | a browser-automation driver the agent steers live | the same tool's committed specs, run via `{{E2E_COMMAND}}` |
| Native mobile | an agent-drivable device/emulator layer over the accessibility/semantics tree | a committed native flow runner |
| API-only | the project's own client, driven live | recorded request/response suites |

Pick per surface on fit, and record a deviation the same way any paved-road departure
is recorded. The reviewer agents are unaffected by the choice — they only ever call the
five verbs.
