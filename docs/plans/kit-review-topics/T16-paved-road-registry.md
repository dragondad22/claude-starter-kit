# T16 — Paved-road tooling registry: preferred frameworks/tools across projects

**Category:** Process improvement (new; from T10 discussion) · **Status:** Decided (2026-07-08) · **Related:** T10 (CI consumes it), T15 (interview recommendations source), T3.7/T3.9 (modules pre-configured with it)

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
