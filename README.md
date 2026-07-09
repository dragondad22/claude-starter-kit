# Claude Starter Kit

A stack-agnostic starting point for working on a project with Claude Code — the
systems, workflows, standards, and quality gates distilled from real projects,
with every project-specific detail turned into a `{{PLACEHOLDER}}` you fill in once.

## Layout

```
template/                   # THE PRODUCT — the only tree scaffolding reads
  manifest.yml              # Allowlist: module -> shipped files -> scaffold trigger
  core/                     # Installed in every project (paths mirror the project root)
    CLAUDE.md               #   Root project context (loaded every session) — template
    .claude/                #   Slash commands (/bootstrap /preflight /qa /security /compliance /perf /release), settings, hooks
    ai/                     #   Standards, checklists, issue templates, automation scripts
    docs/                   #   ADR skeleton, decision log, compliance register, runbooks, workflows, plans
    bootstrap/              #   PLACEHOLDERS.md (token registry), INTERVIEW.md, SETUP.md
    CHANGELOG.md  VERSION  .gitignore  testing-reports/
  modules/                  # Optional — scaffolded in when a trigger fires
    db/                     #   Database schema standard        (first schema/migration)
    ui/                     #   UI standard                     (first UI code)
    reports/                #   UAT process                     (first formal QA/UAT need)
    deploy-ci/              #   Deploy/CD + runbooks            (first deploy target; pending #25)
    sla/                    #   Triage SLA timing layer         (team formation; pending #13)

CLAUDE.md  docs/plans/  …   # Everything outside template/ is kit development — it never ships
```

## How to use it

1. **Scaffold into a new (or existing) repo** — from a kit checkout:

   ```bash
   bash scripts/scaffold.sh /path/to/your-repo [module ...]   # e.g. … db ui
   ```

   Installs every core file (never overwrites existing files), stages all module
   payloads dormant under `bootstrap/modules/` for later trigger-driven installs,
   writes the `bootstrap/KIT_VERSION` upgrade marker, and applies any modules you
   name now. (Hand-copy alternative: copy `template/core/` contents — including
   dotfiles — into the repo root; `template/manifest.yml` lists what ships.)

2. **Run inception.** Open the repo in Claude Code and run **`/bootstrap`** — it generates
   the inception interview (`docs/plans/000-inception/`, from the shipped question bank),
   which you answer asynchronously at your own pace, in the files. When the interview is
   complete, re-running `/bootstrap` consumes the answers: fills every placeholder,
   generates the project README and LICENSE, seeds the founding docs (ADRs, decision log,
   compliance register), and installs the modules the answers call for. (Prefer the manual
   route? Follow `bootstrap/SETUP.md`.)

3. **Verify no placeholders remain.** `/bootstrap` does this automatically. To check by
   hand, search the repo for `{{` (outside `bootstrap/` it should find nothing).

4. **Commit** the bootstrapped state as your first commit.

5. **As the project grows**, module triggers (first schema file, first UI code, first
   deploy target, …) are detected at `/preflight` and offered — install with
   `bash ai/scripts/scaffold-module.sh <module>` from the project root. The same
   interview process reruns for any later epic/feature (`001-<slug>/`, …), producing its
   founding mini-docs and issue breakdown.

## Design principles

- **Stack-agnostic.** Nothing assumes a language, framework, or cloud. Commands and paths
  are placeholders.
- **Process over tooling.** The durable value is the *workflow* — negative-path testing,
  impact-analysis sweeps, decisions-aren't-real-until-recorded, changelog discipline,
  test-integrity audits. That survives any stack change.
- **Loads light.** `CLAUDE.md` stays terse because it's read every session; depth lives in
  `ai/STANDARDS/` and is pulled in only when relevant.
- **Additive over subtractive.** Projects start from a small core and gain modules when a
  real trigger fires — not from a maximal install pruned at the moment of least knowledge.
- **OS-agnostic.** Docs and instructions work on any OS unless explicitly labeled; the only
  exception is the `ai/scripts/*.sh` automation (POSIX shell — Git Bash/WSL on Windows). See the
  OS-agnostic rule in `ai/STANDARDS/DOCUMENTATION_STANDARD.md`.

## Developing the kit

The kit is self-hosting: it develops using the process it ships (typed issues, epics via
sub-issues, decision records in `docs/plans/`, CHANGELOG discipline). Start with the root
`CLAUDE.md`. Improvements made in a downstream project that are generic enough to belong
here should be ported back as issues on this repo.

## License

[MIT](LICENSE) © dragondad22 — the kit repo's README and LICENSE are kit artifacts;
projects generate their own at inception.
