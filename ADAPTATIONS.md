# Adaptations — where this project's instance deliberately diverges

This repo is both the product and an adopter of it (T36). The root `ai/`,
`.claude/`, `docs/` and `bootstrap/` are an **instance derived from
`template/`** at the release pinned in `bootstrap/KIT_VERSION` — not authored
files. `scripts/self-conform.py --check` enforces that, and CI fails on any
divergence *not* listed below.

Every row needs a **reason**. An adaptation without one is drift wearing a
label, and this file is the only place divergence is legal — so it is also the
place it becomes visible. The conformance check reports the row count on every
run precisely so growth is noticed.

Adopting a shipped file unchanged is the norm. Reach for a row here only when
the kit's role as the product genuinely makes the generic file wrong.

## Adapted (the shipped file is wrong for this project)

| Path | Reason |
|---|---|
| `CLAUDE.md` | Kit-development identity: the `template/` separation, manifest allowlist and portable-shell non-negotiables have no generic equivalent, and the file must state which of the two trees governs a given task. |
| `CHANGELOG.md` | The kit's real release history. The template ships an empty skeleton. |
| `VERSION` | The kit's real version — and the thing releases bump. |
| `.gitignore` | Kit-development ignores (fixture output, local scratch) alongside the shipped rules. |
| `.claude/settings.json` | Merged by hand: the kit's own permissions plus the shipped ones. The scaffold can only *copy*, never merge into existing config — the config-merge gap recorded against T32 by T33 and confirmed again in #184. |
| `docs/plans/README.md` | Drops the interview-directory paragraph: this repo's `docs/plans/` holds decision working docs and the closed T-topic register, and has never held an interview directory. **Corrected 2026-08-03** — the previous reason claimed the file was adapted to resolve a routing-rule contradiction, which it never did; T37 resolved that contradiction instead, in favour of the shipped rule. |
| `bootstrap/VERIFY_IGNORE` | Four exclusions no other adopter needs: `template/` (the product tree's tokens are unfilled by design), `CHANGELOG.md` and `docs/plans/` (both quote token syntax when describing it), and `scripts/bootstrap-smoke.sh` (which manipulates token syntax by nature). The GitHub Actions `${{ }}` exclusion was part of this row until v0.13.0 and is now shipped by default (#199). |
| `ai/CHECKLISTS/coding.md` | Adds a kit-specific completion gate: manifest entry, the kit-docs keep-current trigger named by artifact (module / command / structure), `Last Updated` bumps, and the derived-instance rule. The generic checklist cannot name kit artifacts, and an installed-but-unadapted gate does not fire (T36.8) — this is the gate whose absence let epic #145 miss the same rule four PRs running. |

## Seeded (install-once, then owned by this project)

A different kind of legal divergence. These ship as **starting skeletons** the
project is meant to fill — rolling logs, registries, decision records. Diverging
from the template is the file doing its job, not drift, so the check verifies
they **exist** and never compares their content.

Keeping them out of the table above matters: without this split, every log entry
would need an adaptation row, and a list that grows on every ordinary action
stops carrying any signal about real divergence.

| Path | Why it is seeded |
|---|---|
| `docs/evergreen-log.md` | Rolling review record, append-only by design. |
| `docs/GLOSSARY.md` | This project's naming authority. |
| `docs/PERSONAS.md` | This project's persona registry. |
| `docs/architecture/decisions/ADR_INDEX.md` | Index of this project's ADRs. |
| `docs/compliance/COMPLIANCE_REGISTER.md` | What binds this project specifically. |

## Reconciliation log

Each release, `self-conform.py --upgrade` names any declared adaptation that
changed upstream. The judgement made then is recorded here, so the next upgrade
re-reads a decision instead of re-making it.

- **v0.11.0 → v0.12.0** (2026-08-03) — `CLAUDE.md` flagged. Upstream removed a
  redundant `Rules:` header and a blank line from the shipped file's Task Tracking
  section (#174). This repo's `CLAUDE.md` has no counterpart to either line, so
  nothing was portable and the row stands unchanged. *First real self-upgrade;
  the conflict report did its job on its first run.*

