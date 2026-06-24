# Claude Starter Kit

A stack-agnostic starting point for working on a project with Claude Code — the
systems, workflows, standards, and quality gates distilled from a mature project,
with every project-specific detail turned into a `{{PLACEHOLDER}}` you fill in once.

## What's inside

```
CLAUDE.md                 # Root project context (loaded every session) — template
.claude/
  commands/               # Slash commands: /bootstrap /preflight /qa /security /compliance /perf /release /checkpoint
  hooks/                  # Project automation hooks (empty; see README)
  settings.json           # Harness permissions/hooks
ai/
  agent-setup.md          # Living orientation doc for agents
  STANDARDS/              # 13 standards: testing, security, perf, logging, docs, versioning, schema, UI, issues, triage, UAT, external-standards-&-compliance
  CHECKLISTS/             # coding / qa / validation completion gates
  TEMPLATES/              # Report + issue/task templates
  scripts/                # release, version-sync, report scaffolding, self-correction, redaction, security/perf stubs
  self_correction_log.md
docs/
  architecture/decisions/ # ADR template + index
  decision_log.md         # Product/scope decisions
  compliance/             # COMPLIANCE_REGISTER.md — external obligations that bind this project
  workflows/ uat/ sops/ runbooks/ plans/
bootstrap/
  PLACEHOLDERS.md         # Registry of every {{TOKEN}} and its meaning
  INTERVIEW.md            # Questions /bootstrap asks
  SETUP.md                # Manual fill-in checklist (alternative to /bootstrap)
CHANGELOG.md  VERSION  .gitignore
```

## How to use it

1. **Get the kit into a new (or existing) repo.** Easiest, OS-agnostic options:
   - On GitHub, click **"Use this template" → Create a new repository**, then `git clone` it; or
   - `git clone https://github.com/dragondad22/claude-starter-kit my-project`, then start a
     fresh history (delete the `.git` folder and re-init — your OS's file manager or):
     - **macOS / Linux:** `rm -rf my-project/.git && git -C my-project init`
     - **Windows (PowerShell):** `Remove-Item -Recurse -Force my-project/.git; git -C my-project init`
   - For an **existing** repo, copy these top-level entries in: `CLAUDE.md`, `.claude/`, `ai/`,
     `docs/`, `bootstrap/`, `CHANGELOG.md`.

2. **Fill it in.** Open the repo in Claude Code and run **`/bootstrap`** — it inspects the
   repo, interviews you for the gaps, and replaces every placeholder in place. (Prefer the
   manual route? Follow `bootstrap/SETUP.md`.)

3. **Verify no placeholders remain.** `/bootstrap` does this automatically. To check by hand,
   search the repo for `{{` (any editor's project-wide search works; outside `bootstrap/` it
   should find nothing). Cross-platform CLI option, if you have ripgrep:
   ```
   rg "\{\{" -g '!bootstrap/**'
   ```

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
- **OS-agnostic.** Docs and instructions work on any OS unless explicitly labeled; the only
  exception is the `ai/scripts/*.sh` automation (POSIX shell — Git Bash/WSL on Windows). See the
  OS-agnostic rule in `ai/STANDARDS/DOCUMENTATION_STANDARD.md`.

## License

[MIT](LICENSE) © dragondad22

> Maintaining the kit itself? Improvements made in a downstream project that are generic
> enough to belong here should be ported back.
