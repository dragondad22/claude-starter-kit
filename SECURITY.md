# Security

The Claude Starter Kit is a repository of documents and shell scripts that get **copied
into your repository**, where you then run them. It has no server, no runtime and no
account. That makes its security posture narrow but not empty: the kit writes executable
code onto your machine, and it configures what an AI coding agent is allowed to do there.

This file states what it does, so you can decide whether to trust it, and tells you how to
report a problem.

**Last Updated:** 2026-08-16

---

## Reporting a vulnerability

Use GitHub's **private vulnerability reporting** on this repository:

> **Security** tab → **Report a vulnerability**
>
> <https://github.com/dragondad22/claude-starter-kit/security/advisories/new>

The report stays private between you and the maintainer until an advisory is published.
**Please do not open a public issue for a suspected security problem** — use the private
form first, and we can move it into the open together once it is understood or ruled out.

**What to expect.** This is a one-maintainer MIT project. Reports are handled on a **best
effort** basis with **no guaranteed response time**, and fixes land on the **newest
release only** (`SUPPORT.md`). That is the honest commitment; a faster one would not be
kept. If a report turns out to be real, the fix and an advisory are the priority over
anything else in the backlog.

Anything that is not a security problem — a bug, a wrong document, a broken script —
belongs in [the issue tracker](https://github.com/dragondad22/claude-starter-kit/issues),
under `ai/STANDARDS/GITHUB_ISSUES.md`.

---

## What the kit executes

**Installation is `bash scripts/scaffold.sh <target>` from a clone you control.** There is
no installer, no package, no `curl | sh`, and nothing is fetched at install time. You are
trusting the checkout in front of you, and you can read it before you run it — which is
the intended review point.

Scaffolding is **additive**: it copies files and skips any that already exist. It has no
delete path and never overwrites, so it cannot destroy work that is already in the target
repository.

---

## What the kit writes into your repository

### Shell scripts you are expected to run

Nine scripts land under `ai/scripts/` — eight with the core install, one more if you
install the `sla` module. Three of them reach outside the working directory, and those are
the ones worth reading before you run them:

| Script | What it does that is worth knowing |
|---|---|
| `bootstrap-labels.sh` | **Authenticates as you via the `gh` CLI and mutates your GitHub repository**, creating and updating issue labels (`gh label create --force`). It changes remote state, not just local files. `--check` and `--dry-run` are read-only. |
| `performance-smoke.sh` | **Makes outbound HTTP requests with `curl`** to the URL in `PERF_TARGET`, which your project sets. It contacts whatever you point it at, and nothing else. |
| `release.sh` | Rewrites your `VERSION` file(s) and `CHANGELOG.md` in place. Destructive to uncommitted work in those files by design — run it on a clean tree. |
| `scaffold-module.sh` | Copies staged module files into place from `bootstrap/modules/`. Additive, like the initial scaffold. |
| `security-review.sh` | **A stub, not a scanner.** It ships as a starting point you are meant to replace with your stack's real tooling. Do not read a passing run as evidence that anything was scanned. |
| `lib/redact.sh` | Best-effort masking of common credential shapes in generated artifacts. **Explicitly not a guarantee** — it is a second line of defence, never the only control. Keep secrets out of logs at the source. |
| `check-version-sync.sh`, `lint-report-markdown.sh`, `triage-sla-report.sh` (`sla` module) | Read local files and report. No network, no writes outside `testing-reports/`. |

Generated artifacts are written under `testing-reports/`. Because `redact.sh` is
best-effort, **treat that directory as potentially sensitive** and review it before
committing or sharing anything from it.

### AI agent permissions

The kit ships a `.claude/settings.json` containing a permissions **allowlist** — the
security-relevant file in the install, and the one to read first:

```json
"allow": [
  "Bash(ls:*)", "Bash(git status:*)", "Bash(git diff:*)", "Bash(git log:*)",
  "Bash(git branch:*)", "Bash(git add:*)",
  "Bash(ai/scripts/*)", "Bash(bash ai/scripts/*)"
]
```

Everything on that list runs **without prompting you**. Nothing on it commits, pushes, or
touches a remote. `ls`, `git status`, `git diff` and `git log` are read-only; `git add`
stages; `git branch` is the one entry that can *remove* something, since the pattern also
covers `git branch -D` — a local ref, recoverable from the reflog, but worth knowing it is
in there.

The last two entries deserve a deliberate decision rather than a default. They pre-approve
**any** script in `ai/scripts/`, which is a standing grant over a directory whose contents
can change — anything added there later is covered by a permission you granted earlier.
That is a reasonable trade for a directory of project automation you own, and it is not a
trade everyone should accept. **If you would rather not make it, delete those two lines**;
the kit works, with a prompt before each script run.

If you already have a `.claude/settings.json`, the scaffold **will not touch it** — it
skips existing files. You get the kit's permissions only by merging them in yourself.

### Hooks

The kit ships `.claude/hooks/README.md` and `"hooks": {}` — **an empty configuration and
documentation for it**. No hook code ships, and nothing runs around your tool calls unless
you write it yourself.

---

## What the kit does not do

- **It collects nothing and phones nowhere.** No telemetry, no usage reporting, no
  analytics, no callback of any kind (compliance register `B-004`). The only outbound
  requests any shipped script makes are `performance-smoke.sh`'s `curl` to a URL you
  configure, and `bootstrap-labels.sh`'s calls to GitHub as you.
- **It ships no credentials and asks for none.** No secrets are in this repository, and
  `.env` is gitignored in what it installs (`B-001`).
- **It has no dependencies.** Nothing is installed, so there is no dependency tree to
  compromise (`B-003`). The scripts use tools you already have: `bash`, `git`, `sed`,
  and — where noted — `gh` and `curl`.
- **It does not auto-update.** Taking a new release is something you do deliberately.

---

## Supported versions

Fixes, including security fixes, land on the **newest release only**. Earlier releases are
not patched — take the current one. See `SUPPORT.md`.

| Version | Supported |
|---|---|
| Newest release | ✅ |
| Everything earlier | ❌ |

---

## Scope

In scope: anything the kit writes into your repository that could execute unexpectedly,
expose a credential, mutate remote state without your intent, or grant an agent more
authority than this file describes. Also in scope: this file being **wrong** — a claim
here that does not match what the code does is a real finding, and one of the more likely
ones.

Out of scope: vulnerabilities in tools the kit merely calls (`git`, `gh`, `curl`, Claude
Code) — report those upstream; and whatever your own project does with the scripts after
you have adapted them.
