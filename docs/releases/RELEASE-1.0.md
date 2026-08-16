# Release readiness — Claude Starter Kit `1.0`

**Release:** Safe to depend on · **Version:** `1.0.0`
**Status:** Preparing
**Milestone:** [`1.0 — safe to depend on`](https://github.com/dragondad22/claude-starter-kit/milestone/1)

> **Promise:** A developer who has this repository can install the kit into a new or
> existing project, run that project by it from inception through release, and take a later
> kit release without losing or damaging what they have adapted.
> **Audience:** the named adopters (CrossWise, ShelterSync, life-os) and anyone who clones
> the repo · **Parties:** the adopting developer; the maintainer

This record is written *while* the release is prepared and kept afterwards. It holds what
was promised and the evidence behind shipping it. **It does not mirror the scope** —
membership lives in the milestone, and a copied list drifts.

First written 2026-08-14 by the #242 run. Reasoning:
`docs/plans/2026-08-14-kit-release-identity.md`.

**Updated 2026-08-16** — the security-posture and support-commitment gates went green
(#259, #260); the restore and rollback gates were re-pointed at a real issue (#276).

---

## 1. Scope

| | Count | Where |
|---|---|---|
| Committed | 15 (9 closed, 6 open) | The milestone |
| Removed after commitment | 0 | Below — deferral is a recorded removal with a reason |
| Triggered (out until an event fires) | 2 | `triggered` label, and one recorded decision |

Nothing has been removed after commitment. The milestone was created on 2026-08-14 with
ten items; the count is a live read of the milestone, not a snapshot, because a copied list
drifts. **#276** was added on 2026-08-16 — see § 5 for why it existed as work before it
existed as an issue.

The two triggered items are **#257** (Homebrew tap and Scoop bucket — event: the two public
repositories exist; belongs to 2.0's area, not this one) and **`CONTRIBUTING.md`** (event:
the first outside PR; decided 2026-08-12, not yet an issue because nothing is owed until it
fires).

**Reverse-pass questions** — what walking the promise raised, and how each resolved.
Full walk in the working doc § 5.2.

| Promise step | Party | Requires | Resolution |
|---|---|---|---|
| Find / acquire | Adopting developer | The repository, `git clone` | Already handled — 1.0's audience is defined as people who have it |
| Install | Adopting developer | Scaffold, then fill | Already handled — `scaffold.sh` + `/bootstrap`, evidenced by `bootstrap-smoke.sh` on ubuntu and macos |
| Operate | Adopting developer | Standards, commands, session protocol | Already handled — `docs/kit/WORKFLOW.md` |
| Take a later release | Adopting developer | Knowing one exists, and what taking it does | **Gap** — tracked as #258 |
| Take a later release | Adopting developer | Knowing what left the kit | **Gap** — tracked as #265 |
| Take a later release | Adopting developer | A stable upgrade marker | Already handled elsewhere — `bootstrap/KIT_VERSION` becomes #248's merge base and will be formalised there |
| Report a problem | Adopting developer | A channel and a posture | **Closed** 2026-08-16 — `SECURITY.md` + private vulnerability reporting (#259) |
| Know what to expect | Adopting developer | A support commitment | **Closed** 2026-08-16 — `SUPPORT.md` (#260) |
| Contribute | Adopting developer | `CONTRIBUTING.md` | Triggered — event is the first outside PR (decided 2026-08-12) |
| Cut a release | Maintainer | `release.sh` at an alternate root | Already handled — #45 |
| Cut a release | Maintainer | A parseable CHANGELOG | **Gap** — tracked as #264 |
| Cut a release | Maintainer | Guidance matching the standard | **Gap** — tracked as #263 |
| Re-derive the instance | Maintainer | `self-conform --upgrade/--apply` | **Gap** — tracked as #262 |
| Evidence the promise | Maintainer | `upgrade-smoke.sh` | **Decision needed, not an issue** — it tests one hop from the second-newest tag, evidencing *a* release rather than *any* 1.x. Adequate for 1.0; revisit at 2.0 when #248 replaces the mechanism |
| Run the prescribed tracker | Maintainer | The shipped label set | **Gap** — tracked as #261 |

Eight gaps, all tracked and all in the milestone. The full walk — seventeen candidates,
with the find/acquire and contribute steps split per party — is in the working doc § 5.2;
the rows above collapse a few of them.

---

## 2. Universal gates

Every release. Evidence with a date, never a bare tick.

| Gate | Owner | Status | Verified | Evidence |
|---|---|---|---|---|
| Every committed capability **accepted**, not merely built | Chris | ◐ | 2026-08-14 | `scripts/selftest.sh` green on ubuntu and macos in `.github/workflows/kit-selftest.yml`, covering the install path (`bootstrap-smoke.sh`) and the upgrade path (`upgrade-smoke.sh`). Three projects run the kit in earnest — ShelterSync in production since 2026-05-15. **Judged, not checked:** no `AC-` rows exist to verify against (see below). Re-assess when the milestone empties. |
| External providers verified **in production** | Chris | ➖ N/A | 2026-08-14 | 1.0 has no runtime, no deployed environment and no distribution channel: the kit is files copied into a repository from a clone. Consistent with compliance register B-001. **Not a skipped row** — the gate becomes live at 2.0, where the provider is GitHub Releases and the `curl … \| sh` installer, and "verified in production" means a real install on each target platform. Ported back as #267. |
| Restore **tested**, recovery objectives met | Chris | ☐ | — | No data to restore, and the honest reading is not "not applicable": the question is whether an adopter can get back to the state before they took a release. Testable today — `scaffold.sh`'s `copy_into()` skips existing files, so nothing is destroyed and reverting the adoption commit restores the tree. **Needs a demonstration, not an argument.** Shares its evidence with the rollback row; tracked as **#276**, ported back as #267. |
| Security posture current for what this release exposes | Chris | ✅ | 2026-08-16 | `SECURITY.md` — states what the kit executes, what it writes (nine shell scripts across core and the `sla` module; `.claude/settings.json` permissions; an empty hooks config), and what it does not do, each claim checked against the code and against register rows B-001/B-003/B-004 rather than asserted. Reporting channel is GitHub **private vulnerability reporting**, enabled on the repository 2026-08-16 and verified by API — the file does not point at a form that does not exist. Closed by **#259**. *Two things the write-up surfaced rather than restated: the shipped allowlist pre-approves `Bash(ai/scripts/*)`, a standing grant over a mutable directory, now called out with instructions to remove it; and `security-review.sh` is a stub, so a passing run is not evidence of a scan.* |
| Rollback **planned and demonstrated** | Chris | ☐ | — | Same evidence as the restore row. For a first named release there is nothing to roll back *to*, so the gate is exactly planned-and-demonstrated: the procedure written down, and shown to work once. Tracked as **#276** — previously routed to "#259's PR", which was never in that issue's scope. |

**Step 3 of `/readiness` could not run.** The command asserts against `AC-` rows per
committed capability, `INV-` rows against the assembled product and `NFR-` rows at the
release's expected scale. `docs/registers/PRODUCT_REGISTER.md` has none — every section is
an empty skeleton — and there is no journey registry, because the review module's trigger is
a driveable UI the kit does not have. **This whole record's need-limb evidence is therefore
judged rather than checked.** Backfill tracked as **#268**; the missing home for journeys in
a project the review module does not fit is part of #267.

---

## 3. Triggered gates

Conditions checked explicitly, including the ones that do not hold.

| Condition | Applies? | Gate | Owner | Status | Verified | Evidence |
|---|---|---|---|---|---|---|
| Ships through an app store | **no** | Submission accepted | Chris | ➖ N/A | 2026-08-14 | No mobile or desktop store distribution. Re-check at 2.0 if Homebrew or Scoop (#257) is judged store-like; it is not, but the question should be asked rather than assumed. |
| Publishes policies | **yes** | Every published claim honoured and evidenced | Chris | ☐ | — | An open-source project publishes the README's claims and the LICENSE, and they are auditable exactly as a privacy policy is. Claims to audit: "stack-agnostic", "never overwrites existing files", bash-3.2/macOS portability, the module trigger table, `docs/kit/` accuracy, and — added 2026-08-16 — every claim in `SECURITY.md` and `SUPPORT.md`, which became policy-limb documents the moment they were published. Not yet run. That the standard's document set had to be reinterpreted is ported back as #267. |
| Takes payment | **no** | Obligations disclosed; billing verified | Chris | ➖ N/A | 2026-08-14 | MIT, no money moves. The commercial limb is empty for both named releases; register row B-003. |
| Has dependent users | **yes** | A **documented support commitment** | Chris | ✅ | 2026-08-16 | `SUPPORT.md` — best effort, **no guaranteed response time**, fixes on the **newest release only**, and an explicit list of what is *not* promised (backports; support for an adapted or partially upgraded instance; any release date). GitHub surfaces it in the issue-creation flow, so it reaches the audience at the moment they need it. Closed by **#260**. *The gate does not require a generous commitment, only a stated one — and a one-maintainer MIT project cannot keep a generous one. `SUPPORT.md` now joins the published-claims audit below, since it is a promise future releases are measured against.* |

---

## 4. Aspirational

Goals, never gates — visible and owned, blocking nothing.

| Goal | Owner | Criterion that activates it |
|---|---|---|
| Signed / notarised binaries | Chris | A distribution route that requires them. T32.4 records unsigned as deliberate for Releases, `curl \| sh`, Homebrew and Scoop. |
| Homebrew tap and Scoop bucket (#257) | Chris | The two public repositories exist. Filed as `triggered` scope rather than aspirational — noted here so the two are not confused. |
| A published documentation site | Chris | The kit has users who arrive without a clone — i.e. 2.0 has shipped. |
| Outside contributors | Chris | The first outside PR, which is also `CONTRIBUTING.md`'s trigger. |

---

## 5. Gates with no evidence

**A gate that is nobody's issue is nobody's problem.**

| Gate | Issue | In this release? |
|---|---|---|
| Restore tested | **#276** — filed 2026-08-16. #265 covers the removal half | **Yes** — universal |
| Security posture | #259 — **closed 2026-08-16**, `SECURITY.md` | **Yes** — universal |
| Rollback planned and demonstrated | **#276** — filed 2026-08-16 | **Yes** — universal |
| Published claims honoured | Audit runs against #260's and #259's output, now published and therefore auditable; file separately if the audit finds a claim that is not true | **Yes** — trigger has fired |
| Documented support commitment | #260 — **closed 2026-08-16**, `SUPPORT.md` | **Yes** — trigger has fired |

**Two gates were being held by a cross-reference rather than an issue.** Restore and
rollback both pointed at "#259's PR", which was never in that issue's scope — so the work
would have vanished when #259 closed, and the record would still have read as though
someone owned it. Filed as **#276** on 2026-08-16. That is the failure mode § 5 exists to
catch, caught by the section itself on its first re-read.
| Capability acceptance, checkable rather than judged | #268 | **No** — stretch. Upgrades the evidence; the gate itself is met by the suite and three real adopters. |

---

## 6. Sign-off

A gate that cannot be automated is human-attested, dated, and named.

| Who | What they attest | Date |
|---|---|---|
| Chris | Release identity — the archetype, both promises, and that MAJOR is reserved for a landed promise | 2026-08-14 |
| Chris | Membership — the forward and reverse passes, and that the eight gaps found are the ones worth blocking on | 2026-08-14 |
| | Universal and triggered gates green with evidence | *(pending — the release cannot ship until this row is signed)* |
