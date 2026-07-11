# T4 — Bootstrap doesn't touch `README.md` or `LICENSE`

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
