# Claude Starter Kit

A stack-agnostic starting point for working on a project with Claude Code — the
systems, workflows, standards, and quality gates distilled from a mature project,
with every project-specific detail turned into a `{{PLACEHOLDER}}` you fill in once.

## What's inside

```
CLAUDE.md                 # Root project context (loaded every session) — template
.claude/
  commands/               # Slash commands: /bootstrap /preflight /qa /security /perf /release /checkpoint
  hooks/                  # Project automation hooks (empty; see README)
  settings.json           # Harness permissions/hooks
ai/
  agent-setup.md          # Living orientation doc for agents
  STANDARDS/              # 12 standards: testing, security, perf, logging, docs, versioning, schema, UI, issues, triage, UAT
  CHECKLISTS/             # coding / qa / validation completion gates
  TEMPLATES/              # Report + issue/task templates
  scripts/                # release, version-sync, report scaffolding, self-correction, redaction, security/perf stubs
  self_correction_log.md
docs/
  architecture/decisions/ # ADR template + index
  decision_log.md         # Product/scope decisions
  workflows/ uat/ sops/ runbooks/ plans/
bootstrap/
  PLACEHOLDERS.md         # Registry of every {{TOKEN}} and its meaning
  INTERVIEW.md            # Questions /bootstrap asks
  SETUP.md                # Manual fill-in checklist (alternative to /bootstrap)
CHANGELOG.md  VERSION  .gitignore
```

## How to use it

1. **Copy the kit into a new (or existing) repo.** For a new repo:
   ```bash
   cp -r /mnt/DATA/source/claude-starter-kit my-project && cd my-project
   rm -rf .git && git init
   ```
   For an existing repo, copy `CLAUDE.md`, `.claude/`, `ai/`, `docs/`, and `bootstrap/` in.

2. **Fill it in.** Open the repo in Claude Code and run **`/bootstrap`** — it inspects the
   repo, interviews you for the gaps, and replaces every placeholder in place. (Prefer the
   manual route? Follow `bootstrap/SETUP.md`.)

3. **Verify no placeholders remain:**
   ```bash
   grep -rn '{{' . --include='*.md' --include='*.sh' --include='*.json' --include='*.txt' | grep -v '/bootstrap/'
   ```
   Should print nothing.

4. **Prune.** Delete optional standards you don't need (e.g. `UI_STANDARD.md` if there's
   no UI, `DATABASE_SCHEMA_STANDARD.md` if there's no database). `/bootstrap` offers this.

5. **Commit** the bootstrapped state as your first commit.

## Design principles

- **Stack-agnostic.** Nothing assumes a language, framework, or cloud. Commands and paths
  are placeholders.
- **Process over tooling.** The durable value is the *workflow* — negative-path testing,
  impact-analysis sweeps, decisions-aren't-real-until-recorded, changelog discipline,
  test-integrity audits. That survives any stack change.
- **Loads light.** `CLAUDE.md` stays terse because it's read every session; depth lives in
  `ai/STANDARDS/` and is pulled in only when relevant.

> Maintaining the kit itself? Improvements made in a downstream project that are generic
> enough to belong here should be ported back.
