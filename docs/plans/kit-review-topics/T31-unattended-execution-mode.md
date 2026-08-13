# T31 — Unattended (AFK) execution mode: coordinator + serial coding agents

> **Design decided 2026-07-20 (grilling session with Chris). Implementation is deferred
> pending [T32](T32-kit-runtime-evolution.md) (kit runtime/delivery evolution) — the
> enforcement needs catalogued here are requirements input to T32.**

**Category:** Process + Module (new capability) · **Status:** **Decided (2026-07-20)** — **unblocked 2026-08-13: T32 decided; implementation is T32's phase 5, filed under epic #160** · **Issue:** epic #160 (filed 2026-08-03; unblocked by #159 closing, sub-issues decomposed now) · **Related:**

> **Amendment (2026-08-13, from the [T32](T32-kit-runtime-evolution.md) grill).** Two items
> below change under the decided substrate:
> - **T31.13 — the run journal and T32.9's event log are the same artifact**, not two.
>   It is the kit's only state channel: run state, cross-kit message channel, watchdog
>   liveness source, and workbench feed.
> - **T31.1 — the one-writer-per-repo lock is potentially *cross-kit*, not intra-kit.**
>   T32.8 established that the Claude and Codex kits are independent implementations that
>   may collaborate on one repo, so the lock is a protocol both must honour rather than a
>   private mechanism.
>
> **T31.14 ("only the watchdog is throwaway if T32 replaces the substrate") is confirmed** —
> the standards, commands, journal schema and all judgment protocol migrate unchanged; the
> shell watchdog is never written, because it is built natively in `csk` at phase 5. T32 (blocking dependency — delivery substrate), T2 (portable-shell constraint the watchdog strains), T22 (context economy → firewall + journal), T18 (upgrade path signal)

**Problem / Origin:** Chris works sessions to ~50–75% context and stops to avoid compaction, because compaction introduces uncertainty in *coding* sessions specifically. He wants long-running / larger batches (motivating case: run CrossWise's issue backlog while AFK — "nothing gets done if I have to sit there") without that risk, and not as a default mode; ShelterSync would grant a low/zero autonomy ceiling. Grilled 2026-07-20 across 11 questions; the design below is the result. This is genuinely epic-sized and, per the sequencing decision, waits on T32.

**Decision (2026-07-20):**

- **T31.1 — Form: mostly protocol, thin enforced floor.** The judgment surface (decomposition, gating, defer decisions) is *protocol* a coordinator follows — a standard + slash commands. Only the guardrails that must not depend on the model's own degrading judgment get real teeth: a runaway/liveness kill and a one-writer-per-repo lock. Everything else is protocol because it's judgment anyway.

- **T31.2 — Autonomy is a per-project ceiling, explicitly granted.** The setting isn't *which mode* but the *ceiling of autonomy* the user has granted this project. The AI infers where to operate beneath the ceiling and may always drop toward caution, never rise above it. Standards and decisions are never autonomous. CrossWise grants a high ceiling; ShelterSync low/zero.

- **T31.3 — Budget: two nightmares, two defenses.** (A) *Predictable blowup* (big/expensive backlog, wake to a $10K bill) → defended **ex-ante** by a projected-cost approval gate: the coordinator sums per-issue estimates and refuses to start unattended if the projection exceeds the user's threshold. (B) *Pathological burn* (one broken issue thrashes) → defended **in-flight** by wall-clock + liveness watchdog. Token cost is ex-ante-gated + self-reported, **not** a hard token cap — a true hard cap would need API/SDK usage accounting, narrowing "stack-agnostic." Estimate-overrun is soft signal, never a hard stop.

- **T31.4 — Wrapper vs coordinator split.** The **wrapper** is a dumb watchdog: objective thresholds (wall-clock, no-progress-in-M-minutes), mechanical kill, emits telemetry. No context, no judgment. The **coordinator** holds rich judgment but acts only at **boundaries**, never mid-flight. Telemetry reaches the coordinator as a **pulled snapshot**, never a streamed feed (a stream refills the context the firewall exists to keep empty). Agent reasoning stays fully firewalled — the coordinator ingests only the distilled final report. The wrapper also becomes the data source for a future project dashboard.

- **T31.5 — The coordinator judges *outputs at boundaries*, not *activity mid-flight*.** Objective malfunction (stall/loop) → wrapper detects it better than the coordinator could. Substantive malfunction (progressing but wrong) is invisible in telemetry and is caught at the delivery gate. So there is no mid-flight coordinator monitoring; rejection at the boundary + branch rollback costs at most one issue's budget.

- **T31.6 — Acceptance criteria are author-independent and authored up front.** The coordinator authors each issue's acceptance criteria at decomposition time; they travel in the dispatch brief as an immutable contract. The coder may *add* tests but cannot alter/remove them (else the fox grades its own homework). **Eligibility filter:** "can the coordinator write the acceptance test *now*?" If not, the issue isn't autonomous-eligible — identical to "can't verify without a human" → defer.

- **T31.7 — Delivery gate = separate, fresh, adversarial agent.** Never the coder, never the coordinator. Framed to *disprove*. Checks the diff against four things: issue spec, the pre-authored acceptance criteria, applicable standards, and the predicted blast radius (files touched outside the prediction are flagged even when green).

- **T31.8 — Verdict vs advisory authority classes.** Every non-coding agent is one of: a **verdict agent** (adversarial; judges against author-independent pre-authored criteria; may *gate/block* autonomous delivery) or an **advisory agent** (adversarial framing; suggestions only; *zero* blocking authority; may only append to the report / *draft* issues a human must promote — never auto-file, or advice launders itself into work with no human in between). Anything whose output is a *decision* is advisory-by-construction, which structurally enforces "decisions never autonomous."

- **T31.9 — Supervised plan → autonomous execution.** Decomposition/triage is a *supervised prelude*, not part of the unattended run: the coordinator produces a **plan artifact** (eligible issues, each with acceptance criteria + predicted blast radius + per-issue budget estimate, dependency order, and the deferred pile with reasons). The human approves it — and that approval *is* the T31.3(A) ex-ante budget gate. Only execution + delivery-gating + scheduling run unattended. Trade-off accepted: not "point at a raw backlog and walk away" — there's a short plan-review ritual — but that's minutes, not sitting there all night.

- **T31.10 — Naming: unattended / AFK execution, timing-agnostic.** Not "overnight mode." A 40-minute coffee run and an 8-hour sleep are the same feature with different caps. No duration assumptions baked into caps or artifacts. The deliverable is a **return report** (read when you get back), generated from the run journal.

- **T31.11 — Retry vs defer keyed on an *objective* line: "did the check run?"** *Gate failed to produce a verdict* (install failed, extension hung, timeout, harness crashed, liveness-killed — the check didn't run) → **retry once**, fresh dispatch, no accumulated context (this is the flaky-CI case Chris flagged; retrying re-runs the *check*, not the *work*). *Gate produced a negative verdict* (real assertion failed, standards violation, blast-radius breach) → **defer**, no retry. Retry-for-substantive is a later, ceiling-gated option only.

- **T31.12 — Two circuit breakers; halt scope follows the dependency graph.** Consecutive *negative verdicts* → *plan poisoned* → halt the repo + everything downstream of it. Consecutive *no-verdict/infra* failures → *environment broken* → broad halt (shared infra hits everyone). A halt propagates exactly as far as the failure's downward impact reaches through the dependency graph — smallest scope consistent with the actual reach (Chris: shouldn't halt everything by default). Rollback is trivial: a deferred/failed issue is a branch you don't merge.

- **T31.13 — Coordinator holds no irreplaceable context; the run journal is the single source of truth.** The firewall applied recursively to the top: all run state lives in a **run journal** (append-only; per-boundary *objective facts* — tokens/wall-clock/files-touched/retry-count/verdict-class/defer-reason-code — plus reason-codes and *pointers* to rich artifacts, never narrative prose). A fresh coordinator resumes from it, so compaction is structurally irrelevant everywhere — a stronger guarantee than "stop at 50–75%." One journal, four consumers: wrapper liveness, dashboard, return report, resume. Objective facts are logged unconditionally now (you can't compute a KPI you didn't log) as substrate for the future metrics work. **Fallbacks:** graceful-stop-at-threshold + report = the v1 fallback if durable-resume isn't solid yet; hierarchical ("VP over managers") coordinators = a later scale option, only if boundary-time judgment (not context) becomes the bottleneck.

- **T31.14 — Ships as a module** (`template/modules/`, trigger-scaffolded; opt-in, not core): the coordinator **standard/playbook**, a **portable watchdog script** (the T2-straining piece), **slash commands** (plan / execute), a **run-journal schema**, and **ceiling config** with `{{TOKENS}}` placeholders. Only the watchdog is throwaway if T32 replaces the substrate; the standards, commands, journal schema, and all judgment protocol are substrate-independent and migrate.

**Sequencing decision (Chris, 2026-07-20):** implementation **waits on T32** — evolve the kit's tool/runtime first, then build this feature natively on the evolved substrate rather than shipping a shell v1. So the enforcement needs catalogued here (runaway kill, one-writer lock, budget accounting, journal integrity) become concrete *requirements input* to T32.

**Parked for their own grilling sessions (not designed here):**
- The two adversarial non-coding agent types: a **UAT persona agent** (verdict *if* the app is driveable and intent is handed to it author-independently, else advisory) and a **UX evaluator** (always advisory). → **Grilled 2026-07-28 as [T33](T33-independent-reviewer-agents.md)** (independent reviewer agents), promoted by a ShelterSync production incident. T33's **verdict/advisory tagging** (T33.11) is direct requirements input to this topic's delivery gate (T31.7/T31.8): the falsifiable, evidence-cited findings are exactly the class that gates autonomous delivery. T33 also confirmed the evidence-and-retry rules (T33.13) map onto T31.11's "did the check run?" line.
- **KPIs & metrics:** thrash signatures, code-quality measurement, intended-vs-actual outcome, "is the process improving?", and how to set the T31.13 resume/compaction thresholds empirically.

**Discussion notes:**
- Chris, 2026-07-20: mental model is a manager delegating to employees; accepted the reframe that the metaphor imports a false assumption (observation is free) — for an LLM, attention *is* the conserved resource — so "manager always watching" moves to the dumb wrapper while judgment stays with the coordinator at boundaries.
- Chris, 2026-07-20: prefers to evolve the tool before building the feature (see Sequencing decision + T32).
