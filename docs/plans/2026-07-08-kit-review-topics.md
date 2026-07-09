# Starter Kit Review — Decision Topics

**Created:** 2026-07-08 · **Source:** full-kit review (all standards, checklists, templates, scripts, commands, docs — ~4,000 lines)
**Purpose:** Working list of findings to discuss one by one, add context, and decide on — *before* converting decisions into GitHub issues. This kit seeds all future projects, so decisions here propagate.

**How to use this file:** Each topic has `Status` / `Discussion notes` / `Decision`. Update in place as topics are discussed. When a topic reaches **Decided**, its Decision block becomes the source for a tracked issue. Statuses: `Not discussed` → `In discussion` → `Decided` → `Issue filed (#N)` / `Dropped`.

**Referencing:** topics are `T1`–`T12` (new topics append: T13+); sub-items are numbered `Tn.m` (e.g. `T1.3`); lettered options within a topic are referenced as `T2(a)`, `T6(b)`, etc. IDs are stable — don't renumber when items are resolved or dropped.

**Background (from Chris, 2026-07-08):** The kit was distilled from several real projects through trial and error. Some findings in this list are genuine staleness to clean up; others are practices that *fell off due to expediency, not because they were bad ideas* — those may deserve a better mechanism rather than deletion. Some material was also removed for privacy/redaction, which explains certain gaps. The goal of these discussions is not just to fix issues but to **make the process better**. `IMP` in the examples = "implementation plan" — AI-generated plans that started as markdown files and later moved into GitHub Issues for tracking/visibility.

**Progress:** ✅ **23 / 23 decided** (T1–T17 on 2026-07-08; T18–T23 on 2026-07-09). Issue generation: in progress — see Issue map section. T23.4 ordering constraint: restructure epic first.

---

## T1 — Batch of mechanical bugs (low decision content)

**Category:** Bug fixes · **Status:** **Decided (2026-07-08)** — approved as a batch; re-scope at issue-generation time (several items are mooted by other decisions: T1.1 → report tooling collapsed by T5; T1.4 → SLA file deleted by T6; T1.7 → script retired by T8). Chris: "do what you need to."

Small defects where the fix is unambiguous; grouped so they can be approved as one batch (likely one issue/PR).

- [ ] **T1.1 — `{{IMP_ID}}` never lands in report bodies.** *(→ discussion of the underlying work-item process moved to T13; fix this only in whatever form survives T13.)* `new-report.sh` substitutes `{{IMP_ID}}`, and `bootstrap/PLACEHOLDERS.md` says to leave it in templates — but all four report templates hard-code `Work Item: {{WORK_ITEM_PREFIX}}-NNN` instead. After bootstrap, scaffolded reports contain the literal `IMP-NNN`; the real ID only reaches the filename. Fix: put `{{IMP_ID}}` in the templates' Work Item field.
- [ ] **T1.2 — `preflight.md` has two step 6s** (compliance check and report results).
- [ ] **T1.3 — Completion Gate mismatch:** `TASK_ISSUE_STANDARD.md` says the gate is fixed and lists 4 items; `TASK_ISSUE_TEMPLATE.md` has 6 (adds `/compliance` + PR link). Sync the standard to the template.
- [ ] **T1.4 — Dead reference:** `ISSUE_TRIAGE_SLA.md` cites `ai/scripts/triage-sla-report.sh` — doesn't exist. (Interacts with T6 — if the SLA standard is folded, this vanishes.)
- [ ] **T1.5 — Dead reference:** `TESTING_STANDARD.md` mentions a shipped "evidence-collection script" — doesn't exist.
- [ ] **T1.6 — Dead reference:** `UAT_SOURCE_OF_TRUTH.md` precedence list includes "The product features list" — no such artifact exists or is defined anywhere.
- [ ] **T1.7 — Dead code:** `log-self-correction.sh` contains a heredoc that creates the log with a *different* header than the shipped `ai/self_correction_log.md`. The heredoc never runs (file always exists) and diverges in format.
- [ ] **T1.8 — `CLAUDE.md` Commands block omits `{{E2E_COMMAND}}`** even though the interview collects it and six files reference it.

**Discussion notes:**

**Decision:**

---

## T2 — macOS portability of `ai/scripts/*.sh` vs. the "native on macOS/Linux" claim

**Category:** Bug / OS-agnostic principle · **Status:** **Decided (2026-07-08)** — option (a), portable scripts; kit to be open-sourced

`release.sh`, `new-report.sh`, and `lib/redact.sh` use GNU-only `sed -i` (no suffix arg; release.sh also uses the GNU-only `0,/addr/` form). `release.sh` and `check-version-sync.sh` use `mapfile` (bash 4+; macOS ships bash 3.2). README and `agent-setup.md` claim the scripts run "native on macOS/Linux" — on stock macOS they fail. OS-agnosticism is a headline design principle of the kit.

**Options:**
- (a) Fix the scripts properly: portable `sed` usage (`sed -i.bak` + rm, or awk), replace `mapfile` with `while read` loops. Keeps the claim true.
- (b) Soften the claim: "Linux / Git Bash / WSL; macOS needs GNU coreutils + bash 4".
- (c) Rewrite scripts in a truly portable language later (bigger lift, probably not worth it).

**Recommendation from review:** (a) — the fixes are mechanical and the principle is worth keeping honest.

**Discussion notes:**
- 2026-07-08 (Chris): **the kit is intended to be open-sourced** — out-of-box compatibility with as many systems as possible is the goal (nice-to-have, not hard requirement). → Option (a).

**Decision (2026-07-08): option (a) — make the scripts genuinely portable.**
- Replace GNU-only `sed -i` usage with portable forms (`sed -i.bak` + cleanup, or awk); eliminate the GNU-only `0,/addr/` address form; replace `mapfile` with `while read` loops (bash 3.2-compatible for stock macOS).
- Scope note: the script inventory this applies to has shrunk via T5/T6/T8 retirements (`log-self-correction.sh` gone; `new-report.sh` retired/repurposed; report templates collapsed). Portability fixes apply to the survivors: `release.sh`, `check-version-sync.sh`, `lib/redact.sh`, and the two stubs.
- Add a lightweight portability check to the kit's own CI (the kit repo can run its scripts on a macOS runner — eat the dogfood).
- **Scope addition (2026-07-09, from second-pass review):** kit self-test CI — smoke-test `/bootstrap` against a fixture repo, validate scaffold modules, lint for dead cross-references (the rot class the 2026-07-08 review found by hand).
- The "native on macOS/Linux" claim stays, and becomes true.
- **Open-source context recorded:** also validates prior choices — paved-road registry as a swappable data file (T16.1), stack-agnostic machinery vs. owner data separation, MIT license on the kit repo (T4).

---

## T3 — Size/scope tiering mechanism (the structural gap)

**Category:** Structural — core to the kit's stated goal · **Status:** **Decided (2026-07-08)** — revised direction T3.7–T3.11 confirmed by Chris; T3.1/T3.3/T3.5 superseded as noted

The kit's goal is consistency *adapted to project size/scope*, but its only adaptation levers today are: prune DB standard, prune UI standard, one aside that reports are "optional." Everything else (triage SLAs, four reviewer roles, compliance register, formal UAT evidence) is presented at full mature-SaaS weight for every project. Realistic failure mode: small projects feel the drag and quietly abandon *all* of it — killing the consistency goal.

**Proposed shape (from review — content already exists, this is a declaration layer):**
- **T3.1** — One new interview question: "What scale? (solo/experiment · small team/production · multi-team/regulated)".
- **T3.2** — Tier definitions in README + bootstrap:
  - **Core** (every project): CLAUDE.md, coding checklist, testing standard, versioning/changelog, decision recording.
  - **Standard** (production software): + security review, documentation standard, logging, compliance register.
  - **Full** (teams/regulated): + UAT process, formal report templates, triage SLA, perf smoke.
- **T3.3** — `/bootstrap` prunes (or marks dormant) tiers above the chosen one, same as it prunes DB/UI today.

**Open questions to settle:**
- **T3.4** — exact tier boundaries (e.g. does compliance belong in Standard or Core-when-triggered?).
- **T3.5** — prune vs. mark-dormant (deleting loses the upgrade path; keeping unused files is the fat we're trimming).
- **T3.6** — can a project move up a tier later, and how?

**Decisions here constrain T5, T6, T7, T8.**

**REVISED DIRECTION (Chris, 2026-07-08) — additive scaffolding, not pruning:**
- **T3.7** — Invert the model: the kit installs a **core** set of tools/folders/templates, and everything else is a **module** scaffolded in when interview answers (or later triggers) call for it. Supersedes T3.3 (prune) and moots T3.5 (prune-vs-dormant). Rationale: pruning demands knowing what to delete on day one — the moment of least knowledge; additive matches how projects actually grow.
- **T3.8** — Supersedes T3.1: size/scope is not one question — it *emerges* from the inception interview (see T15). Interview answers produce a scaffold plan, not a tier label.
- **T3.9** — Progressive scaffolding (extends T3.6): defined **triggers** during the project's life add modules when a need appears or a threshold is met. Draft trigger table:
  | Trigger observed | Module offered |
  |---|---|
  | first schema/migration file | DB standard + schema checklist items |
  | first UI code | UI standard + UI/accessibility checklist items + aesthetics-level question |
  | first public/consumed API | OpenAPI obligation + compliance rows |
  | first formal QA/UAT need (e.g. external stakeholder acceptance) | report templates + testing-reports/ |
  | first deploy target | CI module, runbooks |
  Triggers are AI-detected at session start / preflight and **offered, never silently applied** (consistent with the compliance-trigger pattern).
  *(2026-07-08, Chris: PR conventions and triage are **core**, not trigger-scaffolded — removed from the table. Triage **SLA** specifics deferred to T6. Remaining rows agreed in principle; details expected to clarify as other topics settle.)*
- **T3.10** — Module storage: modules ship *inside* the kit copy (e.g. `bootstrap/modules/`) so progressive scaffolding works offline and stays version-consistent; scaffolding copies them into place. (Alternative — fetch from upstream kit repo at trigger time — rejected pending discussion: network dependency, upstream drift.)
- **T3.11** — T3.4 resolution direction: split compliance into a **universal baseline** every project carries (secrets handling, dependency hygiene, license, personal-data basics when any user data exists) and **conditional** rows driven by the existing trigger map. The register gets a pre-seeded Baseline section.

**Discussion notes:**
- 2026-07-08 (Chris): prefers core-plus-scaffolding over pruning (T3.3→T3.7); tier question replaced by interview-driven scaffold plan (T3.1→T3.8); progressive triggers as the project grows (T3.6→T3.9); compliance is part-universal, part-conditional (T3.4→T3.11). Inception interview split out as T15.

**Decision:**

---

## T4 — Bootstrap doesn't touch `README.md` or `LICENSE`

**Category:** Bug / bootstrap completeness · **Status:** **Decided (2026-07-08)**

After `/bootstrap`, a project still has the *starter kit's* README ("How to use it… run /bootstrap") and a LICENSE reading "MIT © dragondad22". The bootstrap file list skips both.

**Proposed:**
- **T4.1** — bootstrap step 8 (hand-off) offers to replace README with a minimal project README (name, tagline, commands, pointer to CLAUDE.md/agent-setup).
- **T4.2** — bootstrap asks about license — keep MIT with new copyright holder, switch, or remove for proprietary work.

**Open question:**
- **T4.3** — should the kit ship a `README.project-template.md` so the replacement is deterministic, or let Claude draft it at bootstrap time?

**Discussion notes:**
- 2026-07-08 (Chris): reframed — the kit's README and LICENSE apply to *the kit repo alone*; in their current forms they are never implemented in any project. Licensing is a **per-project decision**; README is **scaffolded as one of the initial project files** and **kept up to date throughout the project**.

**Decision (2026-07-08):**
- Kit's README/LICENSE stay as-is in the kit repo — they are kit artifacts, not templates to fill.
- **License** becomes a spine question in the inception interview (T15): choice (MIT / Apache-2.0 / proprietary / undecided-yet) with recommendation + default; scaffold writes the chosen LICENSE (or none). Owner/holder comes from the same answers.
- **README** is generated at scaffold time from inception answers (name, tagline, commands, layout, doc pointers) — resolves T4.3: drafted from `Final:` fields, not from a static fill-in template (a light structural skeleton in the scaffold module keeps shape consistent across projects).
- **Keep-current rule:** README falls under the documentation standard's existing same-PR keep-current rule (it is a user-facing doc surface); coding checklist's Documentation section gains a README line (top-level commands / layout / feature list still accurate).
- The original bug (projects inheriting "MIT © dragondad22" and the kit's how-to-use README) is dissolved by the additive-scaffold model: project creation *generates* these files rather than inheriting the kit's.

---

## T5 — Fate of the formal report subsystem (4 templates + `new-report.sh` + `testing-reports/`)

**Category:** Trim / tiering · **Status:** **Decided (2026-07-08)** — reframed as failure-driven diagnostics (T5.3–T5.7)

The TESTER/UAT/SECURITY/PERF "No-Code-Touch" report machinery is inherited from a mature multi-role process. The `/qa`, `/security`, `/perf` slash commands already produce the same validation inline; formal scaffolded reports only pay off in a team/regulated process. `SETUP.md` already hints they're optional.

**Proposed:**
- **T5.1** — keep, but gate behind the T3 tier choice.
- **T5.2** — state plainly in `agent-setup.md`: *small projects — run the slash command, skip the report.*

**Discussion notes:**
- 2026-07-08 (Chris, history): reports were one of the fell-off-for-a-reason ideas. They *always* generated → hundreds of reports; initially committed (report-only commits polluting history), eventually made local-only. Original purpose was era-specific: less-reliable models → surface errors, track code reliability, correct course. Less useful now. Where they ARE useful: **CI/CD** — so AI and humans can see what went wrong and identify patterns. The goal is understanding **failure** in enough detail to fix and course-correct — *not* reporting successes or logging everything.

**REFRAME (proposed 2026-07-08): failure-driven diagnostics, not a reporting subsystem.**
- **T5.3** — Success produces no report: an exit code and a summary line. Routine/success reporting is deleted as a concept.
- **T5.4** — Failure produces a **diagnostic bundle**: what ran (commands, SHAs, env), what failed (exit codes, the failing subset), evidence (logs, artifacts, screenshots/traces where UI), suspected cause + suggested direction. Enough to fix without re-running the failure.
- **T5.5** — Homes: **CI uploads bundles as run artifacts on failure** (never committed — the report-only-commit lesson becomes a rule); local runs write to gitignored `testing-reports/` exactly as they ended up doing.
- **T5.6** — Routing: actionable findings become issues per `GITHUB_ISSUES.md` with the bundle linked; recurring failure *patterns* are T8's territory (cross-incident memory) — link pending T8 discussion.
- **T5.7** — Templates: the four role report templates (TESTER/UAT/SECURITY/PERF) collapse into **one diagnostic-bundle shape** with per-gate sections; keep the good bones (evidence paths, repro, severity, self-correction row), delete success-oriented sections (executive summaries, suites-passed tables). `new-report.sh` is repurposed or retired accordingly.
- Note the symmetry: this is the same on-failure artifact philosophy the UAT standard + Playwright paved-road default already use (screenshot/trace/video **on failure**). Because PR-validation CI is core (T10.1), failure diagnostics ride along as core — no scaffold trigger needed; T5.1/T5.2 are superseded by this reframe.

**Decision:** T5.3–T5.7 confirmed by Chris 2026-07-08 — fully decided. (T5.1/T5.2 superseded by the reframe.)

---

## T6 — `ISSUE_TRIAGE_SLA.md`: fold, tier, or keep

**Category:** Trim · **Status:** **Decided (2026-07-08)** · **Depends on:** T3

Assumes a staffed quality board with SLA clocks (4-hour blocker response) and standups; references a nonexistent script; overlaps heavily with `GITHUB_ISSUES.md` label rules. For an AI-pair or solo workflow it's process theater.

**Options:** (a) fold severity/flow-label rules into `GITHUB_ISSUES.md` and delete; (b) demote to "Full" tier only; (c) keep as-is.
**Recommendation from review:** (a) or (b).

**Discussion notes:**
- 2026-07-08 (Chris): agrees with recommendation; no SLAs on current projects (no dev teams), but triage itself is core (per T3 discussion).

**Decision (2026-07-08):** Core triage rules — label discipline, severity definitions, board placement — merge into `GITHUB_ISSUES.md`; `ISSUE_TRIAGE_SLA.md` is deleted as a standalone core standard. The **SLA timing layer** (response/mitigation windows, escalation) becomes a module scaffolded by a team-formation trigger (T3.9), with the SLA numbers coming from interview answers rather than shipped constants. T1.4's dead script reference disappears with the file.

---

## T7 — `docs/plans/`, `docs/sops/`, `docs/workflows/` stub READMEs with false pointers

**Category:** Trim / fix · **Status:** **Decided (2026-07-08)** (T7.2–T7.5; workflows artifact redesign in T17)

Each README says "See ai/STANDARDS for the relevant standard" — **no standard for plans, SOPs, or workflows exists.** (`docs/uat/` and `docs/runbooks/` at least have real referents.)

**Options:** (a) give each README two real sentences — what belongs here, filename convention, when to create one; (b) delete the empty dirs and let projects add them when needed.

- **T7.1** — Note: `docs/workflows/` and `docs/sops/` are ranked in CLAUDE.md's Source-of-Truth precedence and `docs/plans/` in the UAT precedence — deleting requires touching those lists.

**Discussion notes:**
- 2026-07-08 (Chris): **SOPs** had two original uses — (a) a place to upload a *client's* SOP (their dev conventions/patterns to follow) and (b) project-defined SOPs. (b) is superseded (by standards); (a) just needs a standard home when one exists; otherwise fine deleting the dir. **Workflows** documented user journeys *based on answers to questions* — never worked as well as wanted, but contained useful information (reference examples: WF-ANIMAL-007/008 — ID, domain, status/owner, purpose, scope, personas, preconditions, triggers, happy path, edge cases, data-touchpoints table, business rules, mermaid diagram, revision history). Wants a rethink of how it works and what gets produced; can evolve → spun out as **T17**. **Plans**: fine keeping, but has been a catch-all — wants a defined purpose. **Runbooks**: fine.

**Decision (2026-07-08 — confirmed by Chris, incl. plans charter T7.4):**
- **T7.2 — `docs/sops/` deleted.** Project-defined SOPs are superseded by standards. **Client-supplied conventions** get their standard home in `ai/STANDARDS/` (e.g. `ai/STANDARDS/external/CLIENT_<name>.md`): they *function* as externally-imposed standards, get indexed in CLAUDE.md like any standard, and arrive via an inception question ("any externally-imposed conventions?") or on receipt. Precedence vs. house standards stated on arrival (client constraints usually win — contractual). SOPs row removed from CLAUDE.md source-of-truth precedence.
- **T7.3 — `docs/workflows/` concept retained, directory scaffolded on first workflow doc.** Its precedence rank stays (workflow docs outrank UAT docs when they exist). Template/product redesigned under **T17**, evolving with T15 implementation.
- **T7.4 — `docs/plans/` charter (proposed):** *structured discovery only.* Contents: interview directories (`NNN-slug/` per T15.9) and decision working documents (this topics file is the type specimen). Everything in plans/ precedes tracked work and becomes append-only history once its outputs land (T15.11). **Anti-catch-all routing rule:** a decision → decision log/ADR; work → an issue; operational how-to → runbook; user-facing → docs source of truth; term → glossary. If it isn't structured discovery or a decision working doc, it does not go in plans/.
- **T7.5 — `docs/runbooks/` stays**; README rewritten to state its real job (operational how-tos; logging standard's "where do I find errors"; deploy runbooks arrive with the CD module).

---

## T17 — Workflow docs v2: user-journey artifacts produced by feature interviews

**Category:** Process improvement (deferred design; evolves with T15 implementation) · **Status:** Requirements captured — design deferred · **Related:** T15 (producer), T7.3 (home), UAT standard (consumer)

**Origin (Chris, 2026-07-08):** `docs/workflows/` documented user journeys derived from Q&A (examples: WF-ANIMAL-007/008). "Never worked as well as I wanted... but had useful information. I would want to rethink how all that works and what gets produced. This is something that can evolve."

**Requirements/observations captured now:**
- **T17.1** — The old docs were hand-built interview outputs before the interview process existed. Under T15, workflow docs become a **generated founding artifact of a feature interview** — derived from `Final:` fields, with T15.10 provenance links back to their questions.
- **T17.2** — Good bones worth keeping from the examples: ID convention (`WF-<DOMAIN>-NNN`), personas, preconditions, triggers, happy path, edge cases, data touchpoints, business rules, diagram, status/owner/revision.
- **T17.3** — Failure modes to design against (probe why v1 underperformed): doc rot vs. shipped behavior (no keep-current hook existed); heavyweight sections that end up empty; unclear consumption moment (who reads it, when?). Note the known consumers: UAT (precedence #3) and the AI implementing related features.
- **T17.4** — Defer detailed design to T15 implementation; revisit as the interview process takes shape.

**Additions (2026-07-08, from Chris):**
- **T17.5 — Rename: "workflows" is misleading** — the docs contain more than workflows. Proposed: **feature specs** in `docs/specs/` (ID `SPEC-<DOMAIN>-NNN`), where each spec *leads with a Journey layer*. (Alternative name "journeys" undersells the business rules/data content; "specs" with journey-first structure covers both. Name pending Chris's pick.) CLAUDE.md precedence row renamed accordingly.
- **T17.6 — Two-layer structure (the T13.5 pattern again):** top layer = **Journey** — persona, goal, plain-language steps, simple graphical flow (diagram uses user actions, never table names) — written for non-technical stakeholders to confirm assumptions; must pass a "non-technical reader" test (audience-declaration idea from T14.2). Bottom layer = **Technical spec** — preconditions, data touchpoints, business rules, edge cases — for AI/devs/UAT. One document, one source of truth, ordered by audience; the journey layer is exportable/shareable standalone.
- **T17.7 — Persona registry (gap Chris identified: personas never standardized or centralized):** `docs/PERSONAS.md` — each persona: name, who they are, goals, role/permission mapping (ties to RBAC), context/constraints (environment, device, technical comfort). Seeded by inception's audience questions (T15 spine already asks); extended by feature interviews. Specs reference personas from the registry by name — never redefine inline. Glossary role-term entries cross-link to it.
- **T17.8 — Quality mechanisms (v1 "looked good on paper, missed a lot in practice"):** (a) keep-current hook — spec updates ride the same-PR docs rule; (b) **UAT traceability** — UAT acceptance criteria trace to journey steps and edge-case rows, so a spec that misses reality fails visibly at UAT instead of silently; (c) initial quality via T15's scenario stress-testing (invent edge-case scenarios during the interview, don't just transcribe answers); (d) evergreen drift lens covers spec-vs-behavior divergence.

**Discussion notes:**
- 2026-07-08 (Chris): original goal was documenting user journeys to confirm assumptions with **non-technical stakeholders** via a simple graphical representation; v1 workflows were great technical docs but too technical to share. Quality was inconsistent; some missed a lot in practice → T17.6/T17.8. Personas gap → T17.7.
- Recurring kit-wide pattern noted (3rd occurrence): **every artifact leads with its least-technical audience** — two-layer issues (T13.5), bidirectional glossary (T14), journey-first specs (T17.6). Candidate for a stated design principle in the documentation standard at implementation time.

**Decision:** T17 decided 2026-07-08 as a requirements package (T17.1–T17.8); detailed template design still deferred to T15 implementation (T17.4). Open: final name confirmation for the artifact/directory (T17.5).

---

## T8 — Self-correction subsystem and `/checkpoint` vs. built-in memory

**Category:** Trim → replaced by Standards & Process Evergreening · **Status:** **Decided (2026-07-08)** (T8.3–T8.6)

- **T8.1** — `log-self-correction.sh` (117 lines) automates appending markdown Claude could write directly; modern Claude Code memory covers much of the purpose. Candidates: demote to Full tier, or replace with a one-paragraph convention ("append an entry in this format").
- **T8.2** — `/checkpoint` overlaps with Claude Code's session memory/summarization. If kept: its fallback advice to save checkpoints into `docs/runbooks/` is a category error (a session checkpoint is not a runbook) — fix regardless.

**Discussion notes:**
- 2026-07-08 (Chris): agrees both are obsolete — memory has come a long way, and actual work is tracked as well-documented GH Issues; the original purpose (getting to today's standards through trial and error) is fulfilled. **The surviving principle:** the ability to adapt and find new/better ways of doing things. Claude, tools, and features change constantly. Core principle: *periodically stop and look at what we're doing* — repeating patterns or code? new skills/Claude features to take advantage of? Working name: **Standards and Process Evergreening**.

**Decision (2026-07-08):**
- **T8.3 — Retire:** `log-self-correction.sh`, `ai/self_correction_log.md`, and `/checkpoint` are removed from the kit. Their durable functions are already covered: session continuity → Claude Code memory; work tracking → issues (T13); per-incident failure detail → diagnostic bundles (T5.4); cross-incident learning → the evergreen review below.
- **T8.4 — Replace with `/evergreen` (Standards & Process Evergreening), pending confirm of mechanism.** A periodic review with four lenses:
  1. **Repetition** — are we writing the same code/fix/workaround repeatedly? (candidate for a shared helper, a standard, or a paved-road entry)
  2. **Platform delta** — new Claude Code features, skills, or tool capabilities since last review that we should adopt?
  3. **Standards drift** — do the written standards still match actual practice? (fix the standard or fix the practice — deliberately)
  4. **Date sweep** — paved-road reviewed-dates (T16.5), compliance Verified dates, any other currency-sensitive rows.
- **T8.5 — Cadence + outputs:** session-start check, same pattern as the release trigger — "if >~30 days since last evergreen review, propose one" (also runnable on demand). Findings become tracked issues / decision-log entries / standard updates — never just conversation. **Improvements generic enough for the kit get flagged for upstream port-back** (the README's port-back note finally gets a mechanism instead of a hope). *(T8.4/T8.5 confirmed by Chris 2026-07-08.)*
- **T8.6 — Surfacing (revised 2026-07-08 with Chris's step 0; confirmed):** the review has no standalone report document and **never interrupts the session's actual work**.
  0. **Non-interruptive trigger (Chris):** when the cadence check fires at session start, do NOT propose an interactive review — the human is usually there for a specific task, possibly an emergency; an interruption gets cleared or becomes a distraction. Instead the AI runs the review **in the background / at a natural pause** and **files a GH issue** ("Evergreen review <date>", `type:task` + `evergreen` label) containing the findings and per-finding recommendations. The human reviews it from the board on their own schedule; the interactive discussion happens when the issue is *worked*, not when it's filed.
  1. **Per-finding recommendation taxonomy** (new ≠ adopt — awareness has value on its own): **Adopt** (clear win, low risk) · **Sandbox** (promising — trial in an isolated branch/worktree before any standard changes) · **Aware** (know it exists; not adopting — e.g. dependency pins/compat constraints make it break) · **Rejected** (evaluated, doesn't fit — recorded so it isn't re-litigated). Compatibility/breakage risk noted per finding.
  2. **Actionable accepted findings → issues** on the project board like all work.
  3. **Adoption/change decisions → decision log / ADR**, as any decision.
  4. **Port-back candidates → issues on the starter-kit repo** (cross-repo).
  5. **The run record → one dated entry in rolling `docs/evergreen-log.md`**: date, lenses, findings + verdicts, issue links (or "no findings"). Doubles as the cadence-check timestamp, the provenance breadcrumb, **and the seen-list**: prior Aware/Rejected verdicts are checked before surfacing — an item only re-surfaces if something material changed (new version, constraint lifted).

**T8 Decision status:** T8.3–T8.6 all confirmed 2026-07-08 — **T8 fully decided.**

---

## T9 — Missing: git/PR/branch/commit conventions standard

**Category:** Gap — biggest content gap · **Status:** **Decided (2026-07-08)**

The kit *implies* conventions everywhere (`chore/release-X.Y.Z` branches, `chore(release):` prefixes, `Closes #N`) but never states them. For a kit about process consistency, source-control workflow is the most-touched undocumented process.

**Proposed:**
- **T9.1** — a short `GIT_WORKFLOW` standard (or CLAUDE.md section): branch naming, commit message format, PR description requirements, linking issues, who merges, default-branch protection assumptions.

**Open questions:**
- **T9.2** — full standard file vs. CLAUDE.md section (loads-light principle)?
- **T9.3** — adopt Conventional Commits formally or just a house style?

*(2026-07-08, from T3 discussion: Chris — PR conventions are a **core** standard in the additive-scaffolding model, present in every project from day one, not trigger-scaffolded.)*

**Additional sub-decisions surfaced 2026-07-08:**
- **T9.4** — AI attribution trailers: decide whether AI-authored commits carry an attribution trailer (e.g. `Co-Authored-By: Claude …`) as policy, given the mostly-AI-authored workflow.
- **T9.5** — Merge strategy (squash vs. merge-commit vs. rebase): interacts with T9.3 — under squash-merge, the PR title becomes the commit that survives on main, so commit-format rules apply chiefly to PR titles.

**Discussion notes:**
- 2026-07-08 (Chris): T9.1 agreed. T9.2/T9.3 options requested — see explanation in conversation; summary: T9.2 options = (a) full standard file, (b) CLAUDE.md section, (c) hybrid (rules in CLAUDE.md, depth in a standard); T9.3 options = (a) Conventional Commits formally, (b) house style. Recommendation on record: (c) for T9.2; lightweight-formal CC for T9.3 (types required, scope optional, explicitly NOT driving versioning/changelog — those stay changelog-first per the versioning standard).

**Decision (2026-07-08, all confirmed by Chris):**
- **T9.1** — Core git-workflow standard: branch naming, commit format, PR requirements, issue linking, merge policy. Present in every project (core, per T3).
- **T9.2 = (c) hybrid** — 6–8 terse enforcement rules in CLAUDE.md (branch format, commit format, never commit to main, every PR links its issue, PR-title convention); depth/why/examples in `ai/STANDARDS/GIT_WORKFLOW_STANDARD.md`.
- **T9.3 = lightweight-formal Conventional Commits** — type required, scope optional, `BREAKING` honored; standard explicitly states commit types do NOT drive versioning/changelog (changelog-first model unchanged).
- **T9.4 = no AI attribution trailers** — keep commit messages clean. Note for implementation: Claude Code appends `Co-Authored-By` by default, so the standard/CLAUDE.md must explicitly instruct against it or the tool default wins.
- **T9.5 = squash-merge** — PR title is the surviving commit and must follow CC format; intra-PR commit messages relaxed.

---

## T10 — Missing: CI seed + `.env.example` + dependency-maintenance cadence

**Category:** Gap · **Status:** **Decided (2026-07-08)** — T10.1, T10.3, T10.4 confirmed (T10.2 subsumed by T10.4)

- **T10.1 — CI seed:** `{{CI_SYSTEM}}` is referenced in 5 files, security standard says "wire these gates into CI", agent-setup has an empty CI section — but the kit ships zero CI config. Proposed: one optional, commented `.github/workflows/ci.yml.example` (test + build + version-sync + SCA, TODO markers). Tension to discuss: kit is stack-agnostic *and* forge-agnostic; a GitHub Actions example breaks neutrality (but GitHub is where the kit lives).
- **T10.2 — `.env.example`:** `agent-setup.md` setup step tells users to copy from it and `.gitignore` whitelists it — the file doesn't exist. Ship a stub or drop the mention.
- **T10.3 — Dep maintenance:** SCA-in-CI is covered; nothing says who/when for dependency updates (Renovate/Dependabot or manual cadence). One paragraph in the security standard would do.

**Discussion notes:**
- 2026-07-08 (Chris): CI strategy is context-dependent — one env or many, AWS, different databases, connectors — so CI can't be one static template. `.env.example` was never shipped *because* it depends on project type (ShelterSync has multiple .env files); also raised .env vs. secrets — secrets technically don't belong in .env files at all — and that this hinges on deciding what environments exist or will exist.
- Reframe in response: split CI into **environment-independent PR-validation** (core, scaffolded at bootstrap) vs. **environment-dependent deploy/CD** (trigger-scaffolded later, per T3.9) — the "complicated" part of CI is exactly the part that isn't core.

**Decision (2026-07-08):**
- **T10.1 — DECIDED:** GitHub Actions is the default example. One commented **PR-validation workflow** (test + build + lint + version-sync + SCA) is core functionality: scaffolded at bootstrap, modified as the project continues. Deploy/CD pipelines are NOT part of it — they're a separate module scaffolded when environments/deploy targets are decided (inception answer or later trigger). Forge-agnostic caveat stated in the standard: the durable content is the *gate list* (what runs on PR vs merge vs schedule), which ports to any CI system.
- **T10.3 — DECIDED:** Renovate/Dependabot as the default recommendation for GitHub-hosted projects; cadence + ownership documented in the security standard (one paragraph).

**T10.4 — NEW (replaces T10.2, pending confirm): Environments & config/secrets model as an inception spine section.**
The real gap wasn't a missing `.env.example` — it's that no process decides: what environments exist or will exist (local / dev / staging / prod…); where **config** lives per environment; where **secrets** live (secret store / platform secrets — never committed files, and technically not .env at all); which surfaces need their own env files (multi-app repos → multiple `.env.example`s). Inception (T15) gains an Environments & Config section whose `Final:` answers drive: scaffolded `.env.example`(s) documenting key *shapes* (placeholder values only, per surface), the baseline rule ".env = local dev convenience, gitignored, no real secrets; deployed environments use the platform secret store", and the deploy-CI module's shape when that trigger fires. agent-setup's dangling `.env.example` mention is fixed by whichever files actually get scaffolded.

---

## T11 — Duplication with sync burden (multi-tenant doctrine ×8, pipe-escaping note ×3)

**Category:** Efficiency · **Status:** **Decided (2026-07-08)** — "rules may repeat; rationale may not"

- **T11.1** — The multi-tenant isolation doctrine is stated in ~8 files (DB/security/testing/logging/UAT standards + coding/qa/validation checklists). Checklist repetition is *correct* (gates must be self-contained), but the explanatory versions could live once (security standard) with references elsewhere. As-is, changing the doctrine means an 8-file sweep — the exact drift risk the kit's own Impact Analysis gate warns about.
- **T11.2** — The "markdown table pipe escaping" note appears 3× (testing standard, security standard, security template). Tooling trivia — one mention, not three.

**Question to settle:**
- **T11.3** — where's the line between deliberate redundancy (self-contained gates) and drift-prone duplication? Decide the rule, then apply.

**Discussion notes:**
- 2026-07-08 (Chris): agrees with the proposed rule.

**Decision (2026-07-08):** **"Rules may repeat; rationale may not."** Checklists may restate rules as terse imperative one-liners (gates must be self-contained at point of use), but the explanation — why, threat model, patterns, examples — lives in exactly one standard; every other appearance is one line + a pointer. Doctrine changes = update one explanation + sweep the grep-able one-liners. Tenant-isolation explanation consolidates into the security standard. The pipe-escaping note survives as a single line in the diagnostic-bundle format definition (T5.7 collapsed the other copies).

---

## T12 — Small policy calls (quick decisions, grouped)

**Category:** Misc decisions · **Status:** **Decided (2026-07-08)** (all four)

- [ ] **T12.1 — `{{REPO_SLUG}}`:** interviewed + registered, used nowhere. Use it (CLAUDE.md / agent-setup identity block?) or cut the interview question.
- [ ] **T12.2 — "Never use backticks in issue comments"** (`GITHUB_ISSUES.md`): unexplained scar-tissue rule. State the rationale or delete — rules without reasons get ignored, then all rules do.
- [ ] **T12.3 — severity vs. priority label split** (quality issues vs. task issues): deliberate and documented, but add one cross-pointer sentence in `GITHUB_ISSUES.md` so adopters don't unify them by accident.
- [ ] **T12.4 — CHANGELOG ships with empty `### Added/Changed/Fixed/Security` headers** under `[Unreleased]` — at first release these roll into the version heading as empty sections. Cosmetic; decide whether headers appear on demand instead.

**Discussion notes:**
- 2026-07-08 (Chris): T12.1 agree (cut). **T12.2 — scar confirmed:** issue comments were constantly mangled by backticks and repeatedly had to be fixed → the rule STAYS, now with its rationale stated. T12.3 agree. T12.4 agree.

**Decision (2026-07-08):**
- **T12.1** — `{{REPO_SLUG}}` cut; repo remote detected from `git remote -v` at runtime when needed (T15 rebuilds the interview anyway).
- **T12.2** — Rule **kept**, rationale documented next to it: backticks in issue comments were repeatedly mangled (shell command-substitution in `gh`-style CLI calls is the likely mechanism) and constantly needed fixing. Implementation may add the safe alternative: pass bodies via `--body-file` rather than inline strings.
- **T12.3** — One cross-pointer sentence added to `GITHUB_ISSUES.md` explaining the severity (findings) vs. priority (planned work) split; the label manifest (T13.9) encodes it structurally.
- **T12.4** — Headers-on-demand: section headers appear when the first entry of that type lands. Changelog version of success-is-silent; `release.sh` already tolerates absent sections.

---

## T13 — Work-item / issue process: make GitHub Issues work as both AI memory and human tracking

**Category:** Process improvement (new topic from T1.1 discussion) · **Status:** **Decided (2026-07-08)** · **Related:** T1.1, T6, T12.3

**History:** Implementation plans (`IMP-NNN`) began as AI-generated markdown files once a project was well understood/scoped, then moved into GitHub Issues for tracking and visibility. The triage → generate issue → work issue loop works well; the issue body acts as durable AI memory for a specific piece of work.

**Pain points (Chris, 2026-07-08):**
- **T13.1 — Label standardization** is manual and drifts (kit ships two separate `gh label create` blocks that must be run by hand).
- **T13.2 — Everything is a GitHub Issue** — tasks, bugs, future ideas all in one list; hard to separate current work from future work, and issues from bugs.
- **T13.3 — Epics/features have no clear representation**, even with milestones.
- **T13.4 — Issue language is written for the AI**: lengthy, technically heavy, not readable by humans — but that detail is exactly what makes the issue function as AI memory. Need both audiences served without losing either.

**Proposals on the table (see discussion notes):**
- **T13.5** — Two-layer issue body: short human summary up top; full AI implementation brief in a collapsed `<details>` section. One source of truth, two audiences.
- **T13.6** — Kind separation via GitHub **issue types** (Bug/Task/Feature/Epic) where available (org repos), falling back to `type:*` labels on personal repos; milestones reserved for releases only (aligns with versioning standard).
- **T13.7** — Epics = parent issues using GitHub **sub-issues**; features roll up under them.
- **T13.8** — Current-vs-future via a GitHub **Projects v2** board with a Status field (Backlog / Next / In progress / Done); the AI reads the board, not the raw issue list.
- **T13.9** — Single label manifest file in the kit (e.g. `ai/labels.yml` or a script) applied idempotently at bootstrap — one source of truth for the whole taxonomy, replacing the two drifting `gh label create` blocks.

**Discussion notes:**
- 2026-07-08: Background captured; proposals T13.5–T13.9 drafted. Open: org vs. personal repos (issue-types availability), willingness to make Projects v2 part of the standard setup, how short the human layer must be.
- 2026-07-08 (Chris): **Labels over native issue types** — issue types are org-only; standardization across all repos (incl. personal) wins. **Projects: yes**, with the rule *"All repos need a project and that project needs to be kept up to date."* (Clarified: Projects v2 = GitHub's current Projects product; one project per repo, Backlog is a Status value/view, not a second project.) **Two-layer body: approved** — must not lose any of the AI-memory function the current format provides.

**Decision:** *(per sub-item; T13 overall = Decided when all sub-items land)*
- **T13.6 — DECIDED:** kind separation via `type:*` labels (`type:epic`, `type:feature`, `type:task`, `type:bug`) on every repo — no native issue types. Replaces the bare `task` / `bug` labels in the current standards.
- **T13.8 — DECIDED:** every repo gets one GitHub Project with a Status field (proposed values: Backlog / Next / In progress / Done); saved views for "Current work" (Next + In progress) and "Backlog". New rule for CLAUDE.md task-tracking section: *all repos need a project, and the project must be kept up to date* — the AI moves Status when it starts/finishes work, and treats Backlog as out-of-scope unless asked.
- **T13.5 — DECIDED:** two-layer issue body — human summary (what / why now / done-when, ~5–8 lines) on top, full AI implementation brief in a collapsed `<details>` block; task standard instructs the agent to always expand it. Per-issue Bootstrap list trimmed to task-specific files only (CLAUDE.md / agent-setup are mandated globally already).
- **T13.7 — DECIDED:** epics = parent issue (`type:epic`) with native sub-issues; features under epics; tasks under features. Milestones revert to meaning releases only. *(Verify sub-issue availability on personal repos at implementation time; fallback = task-list-of-issue-links in the epic body.)*
- **T13.9 — DECIDED:** single label manifest in the kit (one script/manifest applied idempotently by `/bootstrap`) as the sole source of the taxonomy; `GITHUB_ISSUES.md` + `TASK_ISSUE_STANDARD.md` drop their own `gh label create` blocks and point at it. Taxonomy: `type:*` (kind, exactly one) · `area:*` (project-defined) · `priority:*`/`severity:*` (by kind) · flow labels (quality findings only).
- **Board-update enforcement:** task-standard lifecycle moves Status mandatorily (start work → In progress, closing PR → Done); session-start board check is the drift-catcher (same pattern as the release-trigger check); `/preflight` NOT burdened with board checks.

---

## T14 — Project glossary: shared AI↔human vocabulary per project

**Category:** Process improvement (new) · **Status:** **Decided (2026-07-08)** · **Related:** T13 (issue language), documentation standard

**Origin (Chris, 2026-07-08):** The "grill-me-with-docs" skill generates a `CONTEXT.md` — essentially a dictionary of terms used throughout the project. The concept is right (a common understanding between AI and human), but the name is misleading/confusing and the format could be better. Real pain: repeatedly having to work through concepts/technology where the *human* lacked the terminology (e.g. "Projects v2"), and conversely the AI needs the project's domain language. Explanations given in chat evaporate.

**Key insight:** the dictionary is **bidirectional** — it serves two directions of teaching:
- Human → AI: the project's domain language (what a "restriction" vs "deactivation" means here, etc.).
- AI → human: technical/platform/standards terms the project relies on (Projects v2, SCA, DPIA, ADR…), in plain English.

**Prior art examined (2026-07-08):** Chris's `/grill-with-docs` skill is a 6-line composition ("run `/grilling` using `/domain-modeling`", explicit-invocation-only). `CONTEXT.md` comes from `domain-modeling`, whose mechanism is in-conversation behaviors: challenge glossary-conflicting usage, sharpen overloaded terms to one canonical choice, and **"update the glossary inline the moment a term is resolved — don't batch."** Worth stealing: (1) `_Avoid_:` alias lists per entry (solves the overloaded-"record" problem); (2) capture-inline-don't-batch as the recording mechanism. Worth rejecting: its rule that general technical concepts don't belong — that makes it one-directional (human→AI only), which is exactly the gap T14 fixes.

**Proposals / decisions:**
- **T14.1 — DECIDED: Name/location:** `docs/GLOSSARY.md`, one file, two sections (*Domain terms* / *Technical terms*).
- **T14.2 — Format:** compact `**Term** — definition` bullets, each with plain-English meaning, "why it matters in this project" where non-obvious, and `_Avoid_:` aliases for overloaded/canonical terms. Header line declares the glossary's assumed audience (per-project adjustable; kit default: "competent developer, new to this project, its domain, and its toolchain").
- **T14.3 — Recording rules (replaces blanket "assume new to programming" level; Chris flagged that as possibly too permissive):** record when any of:
  1. **Explained-in-chat** — a human asked, or the AI had to explain → recorded before session ends. (Self-calibrating: adapts the glossary to its actual readers.)
  2. **Coined** — new domain noun/verb enters schema/code/issues (entity, status value, role name) → recorded at introduction time, confusion not required (glossary serves *future* readers, not just the current pair).
  3. **Overloaded common word** — everyday word with repo-specific meaning ("record" → "animal record") → canonical qualified form + `_Avoid_` aliases.
  4. **Load-bearing external concept** — acronym / platform feature / legal-standards concept the repo depends on (SCA, DPIA, Projects v2) → recorded on first doc/issue use.
  **Don't record:** general programming vocabulary at ordinary meaning — unless rule 1 fired.
  **Mechanism:** capture inline at the moment of resolution (not end-of-session batch). Hooks on existing gates: CLAUDE.md conventions line; DB standard "adding a new table/model" step; issue-creation step; coding-checklist Documentation line as backstop.
- **T14.4 — Bootstrap seeds it:** from interview domain answers + the kit's own standing jargon (ADR, UAT, SCA, DPIA, SemVer…) — never empty on day one.
- **T14.5 — Authority:** glossary is the naming reference for code/docs/issues; AI challenges glossary-conflicting usage on sight; documentation standard's "define terms on first use" points here.

**Discussion notes:**
- 2026-07-08: Topic opened from T13 discussion (Projects-v2 terminology confusion was the live example).
- 2026-07-08 (Chris): one file confirmed (T14.1). Wants recording to be *automatic* against a defined standard, not just explained-in-chat; raised "assume new to programming" as the level but flagged it may be too permissive → replaced by the four rules in T14.3. Emphasized: domain terms must be recorded proactively because the audience is anyone reading the repo, not just the current human; common words carry repo-specific meanings ("record" = animal record vs service record vs music record).

**Decision:** T14.1–T14.5 all confirmed 2026-07-08 as written above.

**Seeding timeline (clarified 2026-07-08):** the kit *ships* `docs/GLOSSARY.md` with the Technical-terms section pre-populated with the kit's own standing jargon (ADR, UAT, SCA, DPIA, SemVer…) — no bootstrap needed for that part. `/bootstrap` (one-time, at project creation) adds the project-specific seeds: domain terms from the interview answers (domain, non-negotiables vocabulary) and any compliance terms whose triggers fire (e.g. DPIA only if minors trigger fires). From then on the glossary grows only via the T14.3 recording rules during normal work — bootstrap never touches it again. **Retrofit path for existing repos:** re-running `/bootstrap` (idempotent-ish) offers to add missing kit pieces — glossary, label manifest, project board — the same mechanism serves upgrades of already-bootstrapped projects.

---

## T15 — Project inception workflow: deep async interview → founding docs → scaffold plan

**Category:** Process improvement (new; the front door of the whole kit) · **Status:** **Decided (2026-07-08)** — T15.1–T15.11 all confirmed, incl. provenance/supersede model · **Related:** T3 (consumes its scaffold plan), T14 (seeds glossary), T4 (README/LICENSE + license spine question), bootstrap/INTERVIEW.md

**Origin (Chris, 2026-07-08):** Every project should start with a structured "grilling" phase — talk through the idea, work through potential problems, settle size/scope/architecture. In ShelterSync the AI generated per-feature markdown question files; Chris answered **in the files, asynchronously** — deliberately, because answers often required research, asking other people, or time to think. In-session Q&A (grill-me and similar skills) failed twice over: shallow questions AND forced-synchronous answering.

**What went wrong with the md-file approach:** question consistency/quality varied wildly; no standard format or structure.

**Requirements:**
- **T15.1** — Coverage: questions must span everything the application will need — problem/users, scope, architecture, implementation approach, infrastructure, design aesthetics, data, security/compliance, testing, operations.
- **T15.2** — Right-sizing intelligence: the interview must make infrastructure-appropriate recommendations (small project ≠ AWS; console app vs UI is a real question; "I don't care what it looks like" is a legitimate aesthetics answer that changes what gets scaffolded).
- **T15.3** — Async-first answering: questions live in files with a standard structure; each question carries context ("why this matters"), options with trade-offs, a **recommended answer**, and a **default** (so unanswered questions can fall back to the recommendation instead of blocking). Chris answers at his own pace; AI re-ingests as answers land; sessions are resumable.
- **T15.4** — Standardized question quality: the kit ships a canonical **question bank / interview spec** (sections + depth requirements + per-question format), fixing the variance problem. AI extends it per-project but the spine is fixed.
- **T15.5** — Outputs: when complete, the interview *produces* the founding artifacts the AI follows for the rest of the project — non-negotiables, initial ADRs, decision-log entries, glossary seeds (T14.4), compliance register rows, and the **scaffold plan** (which modules T3.7 installs).
- **T15.6** — Relationship to `/bootstrap`: bootstrap's current shallow interview (fill tokens) becomes the *last step* of inception, consuming the interview's answers — not a separate parallel questionnaire.

**Design details (from discussion):**
- **T15.7 — Question lifecycle:** each question carries a status — `open` → `in-discussion` → `finalized` (plus `needs-research` / `waiting-on-<who>` for externally blocked, `deferred` for deliberately-postponed-with-default-applied). A **Final:** field holds the settled decision/answer/direction, distinct from the running **Discussion:** log. Same Status/Discussion/Decision shape as this topics file — the T-list process is the dogfood proof of the format.
- **T15.8 — Spine + dynamic follow-ups:** the shipped question bank is NOT the whole interview. Static spine questions (always asked; conversation starters) + AI-generated follow-up questions driven by the answers. Generated questions use the same format and get IDs appended within their section (`Q-ARCH-07+`), so depth is standard but content is per-project.
- **T15.9 — Reusable beyond inception (epics/features):** the same interview process runs for any future epic/feature (e.g. "Foster users" in ShelterSync), producing that epic's founding mini-docs and its issue breakdown (feeds T13.7 epic → sub-issues). Naming convention must anticipate this from day one — inception is just the first instance, not a special case.

**Discussion notes:**
- 2026-07-08: Topic opened. Existing `grilling`/`grill-me` skills rejected as the mechanism: not deep enough, and synchronous-only. The async question-file pattern from ShelterSync is the keeper; the fix is standardizing the question format and shipping the question bank in the kit.
- 2026-07-08 (Chris): question format needs a full status lifecycle (discussions span turns; must see what's finalized and what the final call was) → T15.7. Question list must not be fully static — static openers fine, dynamic follow-ups required → T15.8. Per-section files confirmed, but the process must serve future features/epics too, so naming conventions must be scoped for that from the start → T15.9.
- Proposed naming (pending confirm): `docs/plans/<id>-<slug>/NN-section.md`, where inception is `000-inception` and each epic gets the next id + slug (e.g. `001-foster-users/`), cross-linked to its `type:epic` issue once created.
- 2026-07-08 (Chris): **naming confirmed.** Cross-linking extended: artifacts derived from questions must link back (breadcrumbs so AI/human can recover discussion context). On answer changes: initial instinct = finalized question files become immutable; overrides live in ADRs/decision log explicitly citing the overridden question (so Q-IDs must be standard and intentional). Flagged downside himself: original files go stale and can mislead outside the decision context — asked for a better way → T15.10/T15.11.

**Provenance & supersede model (proposed):**
- **T15.10 — Bidirectional breadcrumbs with qualified Q-IDs.** Q-IDs are short within their file (`Q-ARCH-03`) and always **qualified** in cross-document references: `000/Q-ARCH-03` (interview id + question id) — collision-proof across interviews, grep-able, intentional. Forward links: each question's `Final:` block lists its derived artifacts ("Derived: ADR-003, decision log #7, epic #42"). Backward links: the ADR template and decision-log entry format gain a `Source:` field citing the originating question(s). The interview directory gets an index file summarizing section status + all derived artifacts — the provenance hub for that interview.
- **T15.11 — Append-only, not frozen (resolves the staleness objection).** Finalized question files are append-only *except* two mechanical edits: status flips and supersede stamps. When new information overrides an answer, the override is recorded where decisions live (ADR / decision log, citing `000/Q-ARCH-03`), **and** the question gets a one-line stamp at the same moment: status → `superseded`, plus "Superseded 2026-09-14 by ADR-007 — see ADR-007 for current direction." History stays intact; the stale answer is labeled stale at the point of reading. Same pattern the decision log already mandates ("never edit a recorded decision to mean something different — supersede it") and ADR statuses already implement. Rule of altitude stated explicitly in the process doc: **current truth lives in the derived docs (ADRs, standards, decision log); question files are context/history** — they explain *why*, they are never the spec.

**Decision:**

---

## T16 — Paved-road tooling registry: preferred frameworks/tools across projects

**Category:** Process improvement (new; from T10 discussion) · **Status:** In discussion · **Related:** T10 (CI consumes it), T15 (interview recommendations source), T3.7/T3.9 (modules pre-configured with it)

**Origin (Chris, 2026-07-08):** Standard test frameworks like Playwright aren't needed by every project but are important where they apply (UI testing). What else should be standardized or "preferred" — frameworks, tools — that fits CI/CD scope but not a core standard?

**Concept:** a **paved-road registry** — one file of cross-project tool preferences per category. Not per-project mandates: the *default that wins unless the inception interview surfaces a reason to deviate*, with deviations recorded (ADR) so they're deliberate. Resolves the stack-agnostic tension cleanly: the kit's **machinery** stays stack-agnostic; the registry is a swappable **data file** of the owner's preferences (a fork of the kit edits one file).

**Proposals:**
- **T16.1 — File:** e.g. `bootstrap/PAVED_ROAD.md` (owner-level, ships with the kit; consulted, not copied verbatim into projects). Chosen tools land in each project's standards/CLAUDE.md as that project's reality.
- **T16.2 — Categories (draft; per-category entries name default + when-it-applies):** E2E/UI testing (e.g. Playwright) · unit test framework per language · lint/format · package manager · CI (GH Actions — decided T10.1) · dep maintenance (Renovate/Dependabot — decided T10.3) · DB + ORM/migrations · UI foundation (tokens/component approach) · auth approach · logging shape · secret store · **hosting ladder** (the right-sizing sequence: local → Pi/VPS → managed platform → cloud, with "smallest that works" as the standing rule).
- **T16.3 — Consumption:** T15 interview recommendations cite the paved road ("E2E: Playwright — house default"); T3.9 trigger modules arrive pre-configured with the paved-road choice (first UI code → UI module with Playwright config + the CI job's E2E block uncommented); CI example's commented blocks name paved-road tools.
- **T16.4 — Deviation rule:** projects may deviate, but the deviation is an ADR with a reason ("mobile-only → Maestro instead of Playwright"). Consistency by default, dogma never.
- **T16.5 — Currency:** preferences rot; registry rows carry a last-reviewed date (same discipline as the compliance register's Verified column).
- **T16.6 — Data-format standards category + coin-time application (from Chris's E.164 point):** the registry includes small data-representation standards — E.164 (phone), ISO 8601 (date/time), ISO 4217 (currency), ISO 3166 (country), BCP 47 (language), UTF-8, RFC 5322 (email) — and the **mechanism** that makes them useful: when a new field/entity of a well-known data category is *coined* (schema, API shape, form), the AI consults this section and proposes the standard **at introduction time**, not at rework time. Same coin-time timing as the glossary rule (T14.3 #2). The EXTERNAL_STANDARDS trigger map's existing "dates/encoding/i18n" row points here for the concrete list. Rationale: the registry's job isn't just consistency — it's *discovery*; surfacing standards the human didn't know existed ("would have saved a lot of rework").

**Discussion notes:**
- 2026-07-08: Topic opened from Chris's Playwright question during T10. Note synergy: UAT standard already requires failure screenshots/trace/video — Playwright's defaults satisfy it, an argument for it as the E2E paved road.
- 2026-07-08 (Chris): T16 confirmed, with the addition of smaller data-format standards (E.164 example: didn't know it existed; standardizing up front would have saved substantial rework) → T16.6.

**Decision:** T16.1–T16.6 decided 2026-07-08. Registry categories = T16.2 list + data-format standards (T16.6); consumption per T16.3; deviation via ADR (T16.4); reviewed-date discipline (T16.5).

---

## T18 — Kit downstream upgrade path (template-drift problem)

**Category:** Gap (created by open-sourcing + port-back decisions) · **Status:** **Decided (2026-07-09)** · **Related:** T2 (open-source), T8 (evergreen), README port-back note

**Gap:** upstream flow exists (evergreen port-backs → kit issues) but nothing flows back down — a project scaffolded from kit v0.3 never learns about v0.5. Multiplies across adopters once open-sourced.

**Decision:** projects record the kit version they were scaffolded from (`KIT_VERSION` marker written at inception, listing scaffolded modules + versions); the kit maintains its CHANGELOG per its own versioning standard; `/evergreen` gains a **fifth lens — kit delta**: "newer kit version exists → diff the modules this project uses, propose relevant updates" (findings follow the normal T8.6 issue path with Adopt/Sandbox/Aware/Rejected verdicts). Loop closed: improvements flow up via port-back, down via evergreen.

---

## T19 — Session-start protocol consolidation

**Category:** Gap (created by accumulated decisions) · **Status:** **Decided (2026-07-09)** · **Related:** T8.5/T8.6, T13.8, T3.9, release trigger

**Gap:** four session-start checks now exist, defined in four places — release trigger (versioning standard), board check (T13.8), evergreen cadence (T8.5), scaffold-trigger detection (T3.9). No single ritual = the "fell off due to expediency" failure shape.

**Decision:** one **session-start protocol**, defined in exactly one place (agent-setup.md, referenced from CLAUDE.md per T11's rules-vs-rationale split): the ordered check list, each check **non-interruptive** per the T8.6-0 rule — output is one status line or a filed issue, never a derailment of the task the human arrived with. New checks may only be added to this list, not scattered.

---

## T20 — Interview retrospective (question-bank feedback loop)

**Category:** Gap (closes the loop that motivated T15) · **Status:** **Decided (2026-07-09)** · **Related:** T15, T8 (port-back channel)

**Gap:** the shipped question bank fixes question-quality *floor* but nothing improves it — it fossilizes at launch quality.

**Decision:** when an interview's outputs have been implemented (inception: at first release; epic: when the epic closes), one retrospective question is asked: **"what did the interview fail to ask?"** Answers become port-back issues against the kit's question bank. Every project's interview makes the next project's interview better.

---

## T21 — Data-lifecycle question in the inception spine

**Category:** Gap · **Status:** **Decided (2026-07-09)** · **Related:** T15 spine, T10.4 (environments), runbooks module

**Gap:** T10.4 decides where data lives, nothing decides what happens when it's lost.

**Decision:** the data section of the spine gains a question: backup cadence, restore story, acceptable-loss window — with a right-sized recommendation ("weekend CLI → none, and that's fine" is a legitimate recorded `Final:`). Backup/restore runbook scaffolded only when the answer warrants it.

---

## T22 — Context economy: the guard + the information-architecture principle

**Category:** Design principle + enforcement · **Status:** **Decided (2026-07-09)** · **Related:** T11, T8 (evergreen lens), loads-light principle

**Chris (2026-07-09):** a guard is absolutely needed — but the risk of cutting detail is ending up with a different interpretation than the vision ("concise and efficient without losing the vision"). His working approach, now codified:

**The principle — progressive disclosure with addressability:**
1. **Breadcrumbs over monoliths:** detail lives in referenced files, linked from wherever it's relevant — the information is there *if* needed, and only loaded *when* needed. In token terms: referenced detail across files beats one monolithic always-loaded file, because you only send what the task needs.
2. **Never cut the vision — relocate it:** conciseness is achieved by *moving* detail behind a breadcrumb (per T11: rule stays, rationale relocates), never by deleting it. The test for any trim: can the AI still reach the full intent by following links?
3. **Grep-friendliness as a design requirement:** everything referenceable gets a stable, searchable ID or anchor — the kit already trends this way (ADR-NNN, C-NNN register rows, Q-IDs, T-IDs, SPEC-DOMAIN-NNN, uniform one-liner rules from T11, NNN-slug directories). Codify it: new artifact types must define their ID/anchor convention so the AI can *find* the specific detail it needs instead of loading everything.

**The guard:** CLAUDE.md line budget (~150 lines) checked by the evergreen sweep lens; breach → demote detail to a standard behind a breadcrumb per the principle above — never delete it.

Joins "every artifact leads with its least-technical audience" as the kit's second named design principle; both go in the documentation standard at implementation.

---

## T23 — Kit repo structure: self-hosting kit + `template/` separation + manifest

**Category:** Structural (implementation-enabling) · **Status:** **Decided (2026-07-09)** · **Related:** T3.7/T3.10 (modules), T18 (KIT_VERSION), T2 (self-test CI), T4 (kit's own README/LICENSE)

**Problem:** the repo root currently *is* the template — kit-dev files (this topics file, kit CI, fixtures) and shipped files live shoulder-to-shoulder with no boundary. Untenable once the kit is a real open-source project with its own development history.

**Decision (confirmed by Chris, who expected a restructure):**
- **T23.1 — Physical separation:** repo root = kit development (kit's own CLAUDE.md, README, LICENSE, VERSION, CHANGELOG, `.github/` CI, `docs/plans/`, `test/fixtures/`); **`template/` = the product** — the only tree scaffolding ever reads. Kit-dev files cannot leak into projects because they aren't in the shipped tree.
- **T23.2 — Manifest-driven allowlist:** `template/manifest.yml` maps module → files → scaffold trigger (`template/core/` + `template/modules/<name>/`). Allowlist, not blocklist: new kit-dev files are safe by default. Kit self-test CI validates the manifest (all referenced files exist; no shipped file references kit-dev paths).
- **T23.3 — Self-hosting:** the kit develops using the process it ships — own board, typed issues, plans/ directory, releases. Best test of the process and living documentation for adopters. T18's `KIT_VERSION` = the kit repo VERSION at scaffold time; evergreen kit-delta lens diffs `template/` between versions.
- **T23.4 — Ordering constraint:** the restructure is the **first implementation epic** — everything else builds on the new layout.

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

## Verbatim review context

Full findings detail (file:line evidence) lives in the 2026-07-08 review conversation; every finding was verified against the actual files, not assumed. If a topic needs re-verification in a later session, check the cited file first — the kit may have moved.
