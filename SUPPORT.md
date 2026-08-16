# Support

**Short version: best effort, no guaranteed response time, fixes on the newest release
only.** That is the whole commitment. It is written down so you can decide what to depend
on with your eyes open, rather than discovering the limits during an incident.

**Last Updated:** 2026-08-16

---

## What you can expect

| | |
|---|---|
| **Response time** | **None promised.** Issues are read and triaged when the maintainer next works on the kit. That is usually days, sometimes longer. There is no on-call, no SLA, and no obligation to answer any particular report. |
| **Fixes** | Land on the **newest release only**. Earlier releases are not patched — the fix for anything is to take the current release. |
| **Security reports** | Same best-effort commitment, through a private channel: `SECURITY.md`. A confirmed vulnerability takes priority over the rest of the backlog, but still carries no promised timeframe. |
| **Breaking changes** | Announced in `CHANGELOG.md`, prefixed `**BREAKING:**` and naming whose contract broke. What a MAJOR release means here is recorded in `docs/releases/README.md`. |

This is a one-maintainer MIT project with no commercial relationship behind it. A more
generous commitment would not be kept, and an unkept written commitment is worse than
none.

---

## What is *not* promised

- Any response, within any timeframe, to any report
- Backports or patches to earlier releases
- Support for an instance you have adapted, forked, or partially upgraded — the kit
  expects divergence to be declared, and undeclared divergence is yours to reconcile
- Help with your project's own stack, tooling, or domain. The kit is a process, not a
  framework, and it makes no claim about what you build with it
- That any given release ships on any given date

---

## Getting help

**Something is broken, wrong, or missing** →
[open an issue](https://github.com/dragondad22/claude-starter-kit/issues). Check for an
existing one first. `ai/STANDARDS/GITHUB_ISSUES.md` describes how findings are reported
here, including the `severity:*` label a bug needs to be considered triaged.

**A suspected security problem** → **do not open a public issue.** Use private reporting:
`SECURITY.md`.

**"How do I…?"** → the documentation is the first answer, and it is meant to be enough:
`docs/kit/WORKFLOW.md` for how the process fits together, `docs/kit/README.md` for the
map, `bootstrap/SETUP.md` for installing into a project. If the docs did not answer it,
**that is a documentation bug worth filing** — the kit's whole claim is that a developer
can run a project by it from what is written down.

---

## Helping yourself

Two things make a report far more likely to be actionable, and both are things you can do
without waiting on anyone:

- **`bash scripts/selftest.sh`** reproduces what CI runs. If it fails on your machine and
  passes in CI, that difference is the finding.
- **Your kit version** — `bootstrap/KIT_VERSION` in your project, and the release you are
  comparing against. Most reports resolve to a version gap.

The kit takes port-backs. Every named adopter — CrossWise, ShelterSync, life-os — has
contributed changes that came from using it in earnest, and that path is open to anyone: a
well-described problem from real use is the most useful thing this project receives.

---

## Reporting a problem with this commitment

If something here is untrue — a response you were told to expect and did not get, a fix
that did not land where this says it would — say so in an issue. A support commitment that
has quietly stopped being accurate is a defect in the same way a broken script is, and it
is audited against every release (`ai/STANDARDS/RELEASE_STANDARD.md` § Readiness).
