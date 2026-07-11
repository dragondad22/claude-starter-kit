# T10 — Missing: CI seed + `.env.example` + dependency-maintenance cadence

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
