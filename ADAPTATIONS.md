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

| Path | Reason |
|---|---|
| `CLAUDE.md` | Kit-development identity: the `template/` separation, manifest allowlist and portable-shell non-negotiables have no generic equivalent, and the file must state which of the two trees governs a given task. |
| `CHANGELOG.md` | The kit's real release history. The template ships an empty skeleton. |
| `VERSION` | The kit's real version — and the thing releases bump. |
| `.gitignore` | Kit-development ignores (fixture output, local scratch) alongside the shipped rules. |
| `.claude/settings.json` | Merged by hand: the kit's own permissions plus the shipped ones. The scaffold can only *copy*, never merge into existing config — the config-merge gap recorded against T32 by T33 and confirmed again in #184. |
| `docs/plans/README.md` | Here `docs/plans/` holds the kit's decision records (T-topics), not only interview working docs, so the shipped charter would be wrong about its own contents. |
| `bootstrap/VERIFY_IGNORE` | Three exclusions no other adopter needs: `template/` (the product tree's tokens are unfilled by design), GitHub Actions `${{ }}` expression syntax, and `scripts/bootstrap-smoke.sh` (which manipulates token syntax by nature). |
