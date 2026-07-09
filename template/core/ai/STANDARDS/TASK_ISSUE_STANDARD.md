*Generic standard from the Claude starter kit — adapt to this project. Replace `{{TOKENS}}`; see `bootstrap/PLACEHOLDERS.md`.*

# Task Issue Standard

> Written assuming GitHub Issues, but the structure ports to any tracker
> (`{{ISSUE_TRACKER_KIND}}` at `{{ISSUE_TRACKER}}`). Replace `gh` commands with
> your tracker's equivalent.

## Purpose

Define how implementation tasks are written as issues so that any AI agent (or
human) can pick one up and execute it without needing prior conversation context,
without re-investigating scope, and without making avoidable architectural
mistakes.

This standard is distinct from `ai/STANDARDS/GITHUB_ISSUES.md`, which governs
quality-agent bug reports. Task issues are for **implementing features, closing
gaps, or making deliberate changes** to the codebase.

---

## Who Creates Task Issues

- Project owner / lead — defining new work
- AI agents — breaking down large features into sub-tasks, or filing gaps
  discovered during implementation
- Quality agents — when a finding requires non-trivial new work rather than a
  simple bug fix

---

## Work-Item Hierarchy

Three kinds of planned work, nested via native sub-issues (GitHub):

- **Epic** (`type:epic`) — a parent issue grouping a body of related work. Body
  states the goal and the done-when; the breakdown lives in its sub-issues.
- **Feature** (`type:feature`) — a user-visible capability, a sub-issue of an
  epic when one exists.
- **Task** (`type:task`) — an implementation unit (this standard's subject), a
  sub-issue of a feature or epic when one exists. Standalone tasks are fine.

Attach sub-issues via the issue's "Create sub-issue / add existing" UI or
`gh api` sub-issue endpoints. If the tracker has no sub-issue support, fall
back to a task-list of issue links in the parent body — the hierarchy is the
convention; sub-issues are just its best representation.

**Milestones mean releases only.** Never use a milestone to represent an epic,
sprint, or theme — that's what epics and the project board are for (see
`ai/STANDARDS/VERSIONING_AND_CHANGELOG_STANDARD.md`).

---

## Title Format

Clean imperative verb phrase, under 72 characters. No bracket prefixes — kind,
area, and priority are carried by labels (`type:task`, `area:*`, `priority:*`),
not the title.

Examples:
- `Add HTTP client and navigation foundation`
- `Implement record transfer workflow with history`
- `Add compliance report format distinct from general summaries`

---

## Required Labels

The label taxonomy has one source of truth: the manifest table in
`ai/scripts/bootstrap-labels.sh` (applied idempotently at bootstrap; re-run it
any time labels drift). Do not maintain label lists here or anywhere else.

Labels to apply at creation:

| Label | Purpose |
|---|---|
| `type:task` | The kind label — exactly one `type:*` per issue (`type:epic` / `type:feature` / `type:task` / `type:bug`) |
| `area:<name>` | Functional area — the project defines its own set in the label manifest |
| `priority:critical` | Blocks real-world use or is a security/data boundary gap |
| `priority:high` | Degrades feature completeness significantly |
| `priority:medium` | Noticeable gap but workaround exists |
| `priority:low` | Polish, nice-to-have |
| `<traceability-label>` | Optional tag tying the issue to a planning artifact (e.g. a gap analysis), for traceability |

Priority is for planned work; quality findings use `severity:*` instead
(see `ai/STANDARDS/GITHUB_ISSUES.md` — the scales are deliberately separate).

---

## Required Body Structure — Two Layers

Every task issue body has two layers, in this order, per
`ai/TEMPLATES/TASK_ISSUE_TEMPLATE.md`. One source of truth, two audiences:

1. **Human summary** (top, ~5–8 lines, plain language): what this is, why now,
   and a "Done when" line stating the observable outcome. A non-technical
   reader should understand it without opening anything else.
2. **AI implementation brief** (a collapsed `<details>` block): every section
   below, in template order. This is what makes the issue function as AI
   memory — an agent picks it up with no prior conversation context.

**Implementing agents must always expand and read the `<details>` block in
full.** The human summary is not the spec.

### Bootstrap
The first section of the brief. Lists — in order — the task-specific files the
implementer must read before touching code:
1. Any sub-area `CLAUDE.md` for each area being changed
2. Relevant standards from `ai/STANDARDS/`
3. Relevant checklists from `ai/CHECKLISTS/`
4. Key source files specific to this task

Do not list `CLAUDE.md` or `ai/agent-setup.md` — they are mandated globally for
every session already. Task-specific reading only.

If the Bootstrap section is incomplete, the issue is not ready to implement.

### Context
2–4 sentences describing the current state, the gap, and why it matters. No
implementation details here — just the "what is broken or missing and why does it
matter."

### Governing Decisions and References
Table of every ADR, decision-log entry, workflow doc, or SOP that constrains or
informs implementation. Include the reference ID and a one-line summary of what it
governs for this task.

If no decisions govern the task, note "No existing decision — record one if
implementation reveals a choice."

### Scope — What to Build
Precise, enumerated list of what must be implemented. Include the relevant
specifics for the area, for example:
- API: exact routes (method + path), request/response shape, auth requirements
- DB: schema changes (model/table name, fields, types, relations)
- UI: page or component names, what interactions to support
- Client/mobile: screens, view models, API calls wired

Ambiguous scope = the issue is not ready to implement.

### Out of Scope
Explicit list of adjacent things that must NOT be built in this issue. Reference
deferred decisions where applicable. This prevents scope creep and protects
against an AI agent over-implementing.

### Key Files
Exact file paths (relative to repo root) the implementer must read before writing
code. Order them: data/schema first, then services, then routes, then UI. Do not
list files speculatively — only files that are directly relevant.

### Implementation Notes
Architectural constraints, gotchas, patterns to follow, and non-obvious decisions.
Things that are not in CLAUDE.md but are specific to this task. Examples:
- "State must be set atomically with the record write — follow the existing
  pattern in the relevant service"
- "Use the storage abstraction, not the cloud SDK directly — alternate backends
  must be preserved"

### Acceptance Criteria
Checkboxes. Each criterion must be independently verifiable — a reviewer should be
able to confirm each one without guesswork. Separate functional criteria from
negative-path and non-functional ones.

### Tests Required
Specific enough that the tests can be written without reading additional context.
Include:
- What service/route/component each test covers
- Happy-path scenario
- Auth / tenancy-boundary cases (required for all API changes)
- Edge cases specific to this task

### Docs to Update
Checkboxes. Every ADR, decision-log entry, or workflow/user doc that must be
created or updated as part of this task. An issue is not complete until all doc
updates are made.

### Completion Gate
Standard closing checklist. Do not modify between issues — it ensures consistency:
- `ai/CHECKLISTS/coding.md` fully checked
- All tests passing (run the project's test command in affected areas)
- `/preflight` skill passes
- `/security` skill passes (required if auth, access control, session, or a data
  boundary is touched)
- `/compliance` skill passes; any fired trigger is recorded in
  `docs/compliance/COMPLIANCE_REGISTER.md` (required if the change touches an
  API, UI, mobile release, messaging/UGC, or data handling)
- PR linked to the issue (`Closes #N` in the PR description)

---

## Project Board & Issue Lifecycle

Every repo has exactly **one** project board (GitHub Projects v2 or the
tracker's equivalent) with a single-select **Status** field. The board — not
the raw issue list — is how current work is separated from future work: the
AI and humans both read it.

| Status | Meaning |
|---|---|
| Backlog | Future work — out of scope unless explicitly asked |
| Next | Queued — the agreed next batch |
| In progress | Branch created, work underway (includes in-review) |
| Done | PR merged, issue closed |

Saved views: **Current work** (Status is Next or In progress) and **Backlog**.

**The board is kept up to date — lifecycle moves are mandatory:**
- Starting work on an item → set Status to "In progress".
- PR merged / issue closed → set Status to "Done". Closing an issue (even via
  `Closes #N`) does **not** move its Status by itself — move it, or enable the
  board's built-in "Item closed → Done" workflow (a UI setting; it cannot be
  enabled via API).
- Epics move to Done when their last sub-issue closes.
- At session start, glance at the board for drift (closed-but-not-Done items)
  and fix what you find.

Close issues via the PR description: `Closes #<issue-number>`.

### Board setup (once per repo)

With `gh` and the `project` token scope (`gh auth refresh -s project`):

```bash
gh project create --owner <owner> --title "<project name>"
gh project link <number> --owner <owner> --repo <owner>/<repo>
```

The rest is UI-only — in the project's settings: rename/extend the built-in
Status options to `Backlog / Next / In progress / Done`, create the two saved
views above, and under Workflows enable **"Item closed → Status: Done"** and
**"Auto-add to project"** for the repo. Without the token scope, create the
project itself in the UI too — same steps.

---

## Duplicate Check

Before creating a new task issue (GitHub):
```bash
gh issue list --state open --search "<short phrase> in:title"
```

---

## Relationship to Quality Issues

A quality agent finding (bug, security, perf) that requires substantial new
implementation should be converted to a task issue using this standard. The
original quality issue should be left open and linked from the task issue as
"Upstream finding: #N".

---

## See Also

- `ai/TEMPLATES/TASK_ISSUE_TEMPLATE.md` — fill-in body template
- `ai/STANDARDS/GITHUB_ISSUES.md` — quality agent bug reports
- `ai/agent-setup.md` — full AI tooling context
