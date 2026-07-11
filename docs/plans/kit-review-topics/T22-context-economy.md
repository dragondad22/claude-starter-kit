# T22 — Context economy: the guard + the information-architecture principle

**Category:** Design principle + enforcement · **Status:** **Decided (2026-07-09)** · **Related:** T11, T8 (evergreen lens), loads-light principle

**Chris (2026-07-09):** a guard is absolutely needed — but the risk of cutting detail is ending up with a different interpretation than the vision ("concise and efficient without losing the vision"). His working approach, now codified:

**The principle — progressive disclosure with addressability:**
1. **Breadcrumbs over monoliths:** detail lives in referenced files, linked from wherever it's relevant — the information is there *if* needed, and only loaded *when* needed. In token terms: referenced detail across files beats one monolithic always-loaded file, because you only send what the task needs.
2. **Never cut the vision — relocate it:** conciseness is achieved by *moving* detail behind a breadcrumb (per T11: rule stays, rationale relocates), never by deleting it. The test for any trim: can the AI still reach the full intent by following links?
3. **Grep-friendliness as a design requirement:** everything referenceable gets a stable, searchable ID or anchor — the kit already trends this way (ADR-NNN, C-NNN register rows, Q-IDs, T-IDs, SPEC-DOMAIN-NNN, uniform one-liner rules from T11, NNN-slug directories). Codify it: new artifact types must define their ID/anchor convention so the AI can *find* the specific detail it needs instead of loading everything.

**The guard:** CLAUDE.md line budget (~150 lines) checked by the evergreen sweep lens; breach → demote detail to a standard behind a breadcrumb per the principle above — never delete it.

Joins "every artifact leads with its least-technical audience" as the kit's second named design principle; both go in the documentation standard at implementation.
