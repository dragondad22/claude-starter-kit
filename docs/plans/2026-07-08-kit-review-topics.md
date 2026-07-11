# Starter Kit Review — Decision Topics

**Created:** 2026-07-08 · **Source:** full-kit review (all standards, checklists, templates, scripts, commands, docs — ~4,000 lines)
**Purpose:** Working list of findings to discuss one by one, add context, and decide on — *before* converting decisions into GitHub issues. This kit seeds all future projects, so decisions here propagate.

**How to use this record:** This file is the **index**; each topic lives in its own file under `kit-review-topics/` (`TNN-<slug>.md` — format: `kit-review-topics/TOPIC_TEMPLATE.md`). Each topic has `Status` / `Discussion notes` / `Decision` — update the topic file in place as it's discussed, and mirror the Status in the table below. When a topic reaches **Decided**, its Decision block becomes the source for a tracked issue. Statuses: `Not discussed` → `In discussion` → `Decided` → `Issue filed (#N)` / `Dropped`. *(Split from a single monolith 2026-07-11, issue #97 — topic content moved verbatim; pre-split history is in this file's git log.)*

**Referencing:** topics are `T1`+ (new topics append at the next free number, one file each); sub-items are numbered `Tn.m` (e.g. `T1.3`); lettered options within a topic are referenced as `T2(a)`, `T6(b)`, etc. IDs are stable — don't renumber when items are resolved or dropped; superseded entries are stamped in place, never rewritten.

**Background (from Chris, 2026-07-08):** The kit was distilled from several real projects through trial and error. Some findings in this list are genuine staleness to clean up; others are practices that *fell off due to expediency, not because they were bad ideas* — those may deserve a better mechanism rather than deletion. Some material was also removed for privacy/redaction, which explains certain gaps. The goal of these discussions is not just to fix issues but to **make the process better**. `IMP` in the examples = "implementation plan" — AI-generated plans that started as markdown files and later moved into GitHub Issues for tracking/visibility.

**Progress:** **28 / 30 decided** (T1–T17 on 2026-07-08; T18–T25 on 2026-07-09; T26–T28 on 2026-07-10 — all implemented through v0.7.0). T29–T30 added 2026-07-11 from the life-os trial port-backs (epic #90): **not discussed yet** — their issues (#92, #93) are blocked on these topics.

---

## Topics

| ID | Topic | Status |
|---|---|---|
| [T1](kit-review-topics/T01-mechanical-bugs.md) | Batch of mechanical bugs (low decision content) | Decided (2026-07-08) |
| [T2](kit-review-topics/T02-macos-shell-portability.md) | macOS portability of `ai/scripts/*.sh` vs. the "native on macOS/Linux" claim | Decided (2026-07-08) |
| [T3](kit-review-topics/T03-size-scope-tiering.md) | Size/scope tiering mechanism (the structural gap) | Decided (2026-07-08) |
| [T4](kit-review-topics/T04-bootstrap-readme-license.md) | Bootstrap doesn't touch `README.md` or `LICENSE` | Decided (2026-07-08) |
| [T5](kit-review-topics/T05-report-subsystem-fate.md) | Fate of the formal report subsystem (4 templates + `new-report.sh` + `testing-reports/`) | Decided (2026-07-08) |
| [T6](kit-review-topics/T06-issue-triage-sla.md) | `ISSUE_TRIAGE_SLA.md`: fold, tier, or keep | Decided (2026-07-08) |
| [T7](kit-review-topics/T07-docs-stub-readmes.md) | `docs/plans/`, `docs/sops/`, `docs/workflows/` stub READMEs with false pointers | Decided (2026-07-08) (T7.2–T7.5; workflows artifact redesign in T17) |
| [T8](kit-review-topics/T08-self-correction-memory.md) | Self-correction subsystem and `/checkpoint` vs. built-in memory | Decided (2026-07-08) (T8.3–T8.6) |
| [T9](kit-review-topics/T09-git-workflow-standard.md) | Missing: git/PR/branch/commit conventions standard | Decided (2026-07-08) |
| [T10](kit-review-topics/T10-ci-env-dependencies.md) | Missing: CI seed + `.env.example` + dependency-maintenance cadence | Decided (2026-07-08) |
| [T11](kit-review-topics/T11-duplication-sync-burden.md) | Duplication with sync burden (multi-tenant doctrine ×8, pipe-escaping note ×3) | Decided (2026-07-08) |
| [T12](kit-review-topics/T12-small-policy-calls.md) | Small policy calls (quick decisions, grouped) | Decided (2026-07-08) (all four) |
| [T13](kit-review-topics/T13-issue-process.md) | Work-item / issue process: make GitHub Issues work as both AI memory and human tracking | Decided (2026-07-08) |
| [T14](kit-review-topics/T14-project-glossary.md) | Project glossary: shared AI↔human vocabulary per project | Decided (2026-07-08) |
| [T15](kit-review-topics/T15-inception-interview.md) | Project inception workflow: deep async interview → founding docs → scaffold plan | Decided (2026-07-08) |
| [T16](kit-review-topics/T16-paved-road-registry.md) | Paved-road tooling registry: preferred frameworks/tools across projects | Decided (2026-07-08) |
| [T17](kit-review-topics/T17-feature-specs-v2.md) | Workflow docs v2: user-journey artifacts produced by feature interviews | Requirements captured — design deferred |
| [T18](kit-review-topics/T18-kit-upgrade-path.md) | Kit downstream upgrade path (template-drift problem) | Decided (2026-07-09) |
| [T19](kit-review-topics/T19-session-start-protocol.md) | Session-start protocol consolidation | Decided (2026-07-09) |
| [T20](kit-review-topics/T20-interview-retrospective.md) | Interview retrospective (question-bank feedback loop) | Decided (2026-07-09) |
| [T21](kit-review-topics/T21-data-lifecycle-question.md) | Data-lifecycle question in the inception spine | Decided (2026-07-09) |
| [T22](kit-review-topics/T22-context-economy.md) | Context economy: the guard + the information-architecture principle | Decided (2026-07-09) |
| [T23](kit-review-topics/T23-kit-repo-structure.md) | Kit repo structure: self-hosting kit + `template/` separation + manifest | Decided (2026-07-09) |
| [T24](kit-review-topics/T24-file-naming-convention.md) | Markdown file-naming convention: reference vs working docs | Decided (2026-07-09) |
| [T25](kit-review-topics/T25-roadmap-intake.md) | Feature-request intake & roadmap: views over live issues | Decided (2026-07-09) |
| [T26](kit-review-topics/T26-audience-first-text.md) | Audience-first user-facing text: personas, no internal leakage, human voice | Decided (2026-07-10) |
| [T27](kit-review-topics/T27-rebaseline-conform.md) | Rebaseline: salvage-and-rebuild path for messy / false-start repos | Decided (2026-07-10) |
| [T28](kit-review-topics/T28-uat-acceptance-beta-split.md) | UAT scope: agent-run acceptance vs task-based beta guides; "how do I?" is a design signal | Decided (2026-07-10) |
| [T29](kit-review-topics/T29-project-concept-intake.md) | Project-concept intake: shared understanding before the targeted interview | Not discussed |
| [T30](kit-review-topics/T30-kit-docs-area.md) | Shipped kit-docs area: workflow guide with flowchart + kit reference, keep-current rule | Not discussed |

---

## Issue map (generated 2026-07-09)

GitHub is the source of truth for work status; this file remains the decision record. 36 issues; epics use native sub-issues (verified working on personal repos — T13.7 fallback not needed).

| Epic | Sub-issues | Topics |
|---|---|---|
| **#1 Restructure** — self-hosting kit + `template/` separation *(first, per T23.4)* | #2 move content into template/ · #3 manifest.yml · #4 kit-dev identity · #5 portable shell · #6 self-test CI · #7 mechanical batch | T23, T2, T1, T12.1, T12.4 |
| **#8 Issue process** | #9 label manifest · #10 two-layer template · #11 board convention · #12 sub-issue epics · #13 triage merge + backtick rationale | T13, T12.2/12.3, T6 |
| **#14 Inception & scaffolding** | #15 interview machinery · #16 spine question bank · #17 scaffold engine + KIT_VERSION · #18 /bootstrap rewrite · #19 retrospective · #20 compliance baseline | T15, T3, T4, T20, T21, T18(part), T3.11 |
| **#21 Vocabulary & specs** | #22 glossary · #23 personas · #24 feature specs v2 | T14, T17 |
| **#25 Tooling** | #26 git standard · #27 PR-validation CI · #28 paved road · #29 dep maintenance | T9, T10.1/10.3, T16 |
| **#30 Diagnostics & evergreening** | #31 failure bundles · #32 /evergreen · #33 session-start protocol | T5, T8, T18, T19 |
| **#34 Cleanup & principles** | #35 dedup sweep · #36 design principles + budget | T11, T22 |
| **#90 life-os port-backs** *(added 2026-07-11)* | #91 AI/data-locality spine question · #92 concept intake · #93 kit-docs area · #94 game shape + gamified UI rung · #95 setup checklist | T20 (channel), T29 (#92), T30 (#93); #91/#94/#95 decided at issue level |

Board: project creation blocked at generation time (token scope) — see conversation note; issues #1–#7 are the "Next" set once the board exists.

---

## Second-pass note (2026-07-09)

A "with-full-context, any remaining gaps?" pass produced T18–T22 plus one fold-in: **kit self-test CI** (bootstrap smoke-test against a fixture repo, scaffold-module validation, dead-cross-reference lint) added to T2's implementation scope. All adopted by Chris; all to be included in issue generation.

---

## Suggested discussion order

1. **T3 first** (tiering) — it constrains T5, T6, T7, T8.
2. **T9, T10** (gaps) — new content, shaped by T3's tiers.
3. **T5–T8** (trim decisions) — fast once T3 is settled.
4. **T2, T4, T11, T12** (self-contained calls).
5. **T1 last** (mechanical batch) — likely a single "approved, fix all" once nothing above changes its items.

---

## Verbatim review context

Full findings detail (file:line evidence) lives in the 2026-07-08 review conversation; every finding was verified against the actual files, not assumed. If a topic needs re-verification in a later session, check the cited file first — the kit may have moved.
