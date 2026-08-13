# Release readiness — Claude Starter Kit `<version>`

**Release:** `<the named release, e.g. Limited availability>` · **Version:** `<X.Y.Z>`
**Status:** Preparing | Shipped `<date>` | Abandoned `<date, reason>`
**Milestone:** `<link to the release's milestone — the manifest>`

> **Promise:** the one sentence, copied from `docs/releases/README.md`
> **Audience:** `<who will hold us to it>` · **Parties:** `<everyone it must satisfy>`

This record is written *while* the release is prepared and kept afterwards. It holds what
was promised and the evidence behind shipping it. **It does not mirror the scope** —
membership lives in the milestone, and a copied list drifts.

---

## 1. Scope

| | Count | Where |
|---|---|---|
| Committed | | The milestone |
| Removed after commitment | | Below — deferral is a recorded removal with a reason |
| Triggered (out until an event fires) | | `triggered` label |

**Removed after commitment** — every item taken out of the milestone once it was in it.
A release that shrinks silently is trivially complete.

| Item | Removed | Why |
|---|---|---|
| | YYYY-MM-DD | |

**Reverse-pass questions** — what walking the promise raised, and how each resolved.
*"Already handled elsewhere" is a healthy and common answer; record it so the same
question is not re-asked next release.*

| Promise step | Party | Requires | Resolution |
|---|---|---|---|
| | | | Tracked as `#N` / already handled by … / decision needed / **gap** |

---

## 2. Universal gates

Every release. Evidence with a date, never a bare tick — a tick with no date cannot be
told apart from one copied forward from the last release.

| Gate | Owner | Status | Verified | Evidence |
|---|---|---|---|---|
| Every committed capability **accepted**, not merely built | | ☐ | YYYY-MM-DD | |
| External providers verified **in production** | | ☐ | YYYY-MM-DD | |
| Restore **tested**, recovery objectives met | | ☐ | YYYY-MM-DD | |
| Security posture current for what this release exposes | | ☐ | YYYY-MM-DD | |
| Rollback **planned and demonstrated** | | ☐ | YYYY-MM-DD | |

---

## 3. Triggered gates

Check the condition first; where it holds, the gate is mandatory. Record the ones that
**do not** apply too, with the reason — an absent row and a considered "not applicable"
look identical otherwise.

| Condition | Applies? | Gate | Owner | Status | Verified | Evidence |
|---|---|---|---|---|---|---|
| Ships through an app store | yes/no | Submission **accepted** | | ☐ | YYYY-MM-DD | |
| Publishes policies | yes/no | Every published claim honoured and evidenced | | ☐ | YYYY-MM-DD | |
| Takes payment | yes/no | Obligations disclosed; billing verified end to end | | ☐ | YYYY-MM-DD | |
| Has dependent users | yes/no | A **documented support commitment** | | ☐ | YYYY-MM-DD | |

---

## 4. Aspirational

Goals, never gates — visible and owned, and blocking nothing. Each names the criterion
that would turn its tasks into committed scope.

| Goal | Owner | Criterion that activates it |
|---|---|---|
| | | |

---

## 5. Gates with no evidence

**A gate that is nobody's issue is nobody's problem.** Anything above that could not be
evidenced gets a tracked issue here — and that issue is release scope if the gate is
universal or its trigger has fired.

| Gate | Issue | In this release? |
|---|---|---|

---

## 6. Sign-off

A gate that cannot be automated is **human-attested, dated, and named** — an unsigned
assertion is indistinguishable from an assumption.

| Who | What they attest | Date |
|---|---|---|
| | | YYYY-MM-DD |
