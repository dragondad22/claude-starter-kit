# T14 — Project glossary: shared AI↔human vocabulary per project

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
