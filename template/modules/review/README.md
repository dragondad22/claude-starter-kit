# Module: review

Independent reviewer agents (T33) — agent-driven UAT/UX/data-integrity review that
drives the running app locally as personas, verifies values actually persist, and
re-checks existing flows after a shared-surface change. Scaffolded when the project
has a driveable UI it wants reviewed independently of the author. Files mirror their
project-root-relative destinations:

- `ai/STANDARDS/INDEPENDENT_REVIEW_STANDARD.md` — the single home for the *why*:
  independence rules, verdict/advisory authority classes, the universal invariant
  set, evidence requirements, findings-exit routing, and non-production safety.
- `ai/STANDARDS/REVIEW_DRIVER_CONTRACT.md` — the seam that lets the agents drive any
  surface: the five driver verbs (navigate/act/snapshot/read-back/emit-evidence), the
  `interactive` vs `playback` capability flag, and the verifier's separate storage-read
  channel. Paved-road drivers named per surface; none mandated.
- `.claude/agents/review-uat-driver.md` — persona driver (verdict).
- `.claude/agents/review-data-verifier.md` — data-integrity verifier (verdict).
- `.claude/agents/review-ux-conformance.md` — UX-conformance evaluator (advisory).

**Adapting the agents on install:** the agent files ship with built-in tools only. Wire
your surface's driver per the driver contract and **append its tool to the relevant
agent's `tools` line** — the driver and UX agents need an interactive driver tool; the
verifier needs a storage-read path (Bash is already granted). Only add a tool that is
actually installed: Claude Code refuses to launch a subagent that names an absent tool.
Because subagent frontmatter must begin on line 1, these files carry their adaptation
note in the body rather than a line-1 genericization banner.

- `.claude/commands/review.md` — the `/review` command: the safety gate, the scoper
  (it reads the diff so the agents never do), the run tiers (blast-radius / touched-by-diff
  / critical / full), agent dispatch, findings routing, and `discover` mode.
- `docs/uat/JOURNEY_REGISTRY.md` — the durable list of flows a review can walk
  (`JRN-<DOMAIN>-NNN`), with the **entities/vocabularies-touched** column that drives
  blast-radius scoping and the discovered/authored × unverified/verified status model.

Blast-radius scoping is the untouched-flow catch: a change to a shared vocabulary selects
every journey that *consumes* it, even if its own screens didn't change. `/preflight`
gains a rung that strongly suggests a blast-radius `/review` after a shared-surface change.

Arriving in the next sub-issue of the epic (kept out of this manifest entry until its
content ships, so the allowlist never lists a missing file):

- ratchet (proposal → landed spec) + JSONL run-journal + findings exit (#149).

Introduces the `{{REVIEW_BASE_URL}}` placeholder (`bootstrap/PLACEHOLDERS.md`) — the
non-production target the reviewers refuse to run without.
