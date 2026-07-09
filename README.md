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

1. **Copy the shipped tree into a new (or existing) repo:**
   - Copy the contents of `template/core/` (including dotfiles: `.claude/`, `.gitignore`)
     into your repo root.
   - Copy in any modules that apply — module paths mirror the project root
     (e.g. `template/modules/db/ai/STANDARDS/…` → `ai/STANDARDS/…`).
   - `template/manifest.yml` lists exactly what ships per module.

2. **Fill it in.** Open the repo in Claude Code and run **`/bootstrap`** — it inspects the
   repo, interviews you for the gaps, and replaces every placeholder in place. (Prefer the
   manual route? Follow `bootstrap/SETUP.md`.)

3. **Verify no placeholders remain.** `/bootstrap` does this automatically. To check by
   hand, search the repo for `{{` (outside `bootstrap/` it should find nothing).

4. **Commit** the bootstrapped state as your first commit.

> An interview-driven scaffold engine that automates module selection is in progress
> (epic #14 — inception interview & additive scaffolding).

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
