# Module: review

Independent reviewer agents (T33) — agent-driven UAT/UX/data-integrity review that
drives the running app locally as personas, verifies values actually persist, and
re-checks existing flows after a shared-surface change. Scaffolded when the project
has a driveable UI it wants reviewed independently of the author. Files mirror their
project-root-relative destinations:

- `ai/STANDARDS/INDEPENDENT_REVIEW_STANDARD.md` — the single home for the *why*:
  independence rules, verdict/advisory authority classes, the universal invariant
  set, evidence requirements, findings-exit routing, and non-production safety.

Arriving in later sub-issues of the epic (kept out of this manifest entry until
their content ships, so the allowlist never lists a missing file):

- `.claude/agents/` — the three reviewer definitions + the driver-seam contract (#147).
- journey registry + tiered run commands + blast-radius scoping (#148).
- ratchet (proposal → landed spec) + JSONL run-journal + findings exit (#149).

Introduces the `{{REVIEW_BASE_URL}}` placeholder (`bootstrap/PLACEHOLDERS.md`) — the
non-production target the reviewers refuse to run without.
