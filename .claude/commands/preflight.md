Run pre-commit validation to catch issues before committing.

1. Run `git diff --name-only` to identify changed files and which areas they touch.
2. For the affected areas, run in order:
   - **Build / typecheck**: `N/A (no build step)`
   - **Lint**: `bash -n scripts/*.sh` (skip if N/A)
   - **Tests**: `bash scripts/selftest.sh`
3. Quick security scan on changed files (see `ai/STANDARDS/SECURITY_REVIEW_STANDARD.md`):
   - Missing authorization/permission checks on new entry points
   - Untrusted input used without validation
   - `.env` files or credentials in staged changes
4. CHANGELOG + version checks (`ai/STANDARDS/VERSIONING_AND_CHANGELOG_STANDARD.md`):
   - If the diff ships user-visible behavior but `CHANGELOG.md` is NOT among the changed files, warn: "user-visible change with no `[Unreleased]` entry — add one (skip only for purely internal work)."
   - Run `bash ai/scripts/check-version-sync.sh` and report any version drift.
5. Documentation check (`ai/STANDARDS/DOCUMENTATION_STANDARD.md`):
   - If the diff touches user-visible behavior but no docs were updated, warn and point at the relevant doc surface.
6. Assessment check — did the spec's content actually get filed (`docs/specs/README.md`)?
   - If the diff moves a feature spec to **`Consumed`** but its **`Landed in`** field is empty, **fail**: the behavior was built and the content was never filed, which is indistinguishable from done. Name the spec and what it still declares.
   - If a spec moved to `Consumed` and no register file is among the changed files, **warn**: the content may have landed in an earlier PR, or it may never have landed. Say which by checking whether the spec's declared rows are reachable by ID.
   - This is the mechanical half of the assessment gate in `ai/CHECKLISTS/coding.md`; it catches the omission, it does not judge whether the filing was any good.
7. Compliance trigger check (`ai/STANDARDS/EXTERNAL_STANDARDS_AND_COMPLIANCE.md`):
   - If the diff touches a public API, web UI, a mobile release, messaging/UGC, payments, or personal data, run the trigger map (or suggest `/compliance`). Warn on any fired trigger missing from `docs/compliance/COMPLIANCE_REGISTER.md`.
8. Scaffold-trigger check (trigger table: `bootstrap/modules/manifest.yml`):
   - If the diff introduces a first-of-its-kind artifact — first schema/migration file, first UI code, first public/consumed API, first formal QA/UAT need, first deploy target — and the matching module is not installed (`bash ai/scripts/scaffold-module.sh list`), **offer** the module install. Never apply a module silently.
9. Shared-surface change check (if the review module is installed):
   - If the diff touched a shared surface — an enum/lookup vocabulary, a DB column/constraint, a seed/default, a shared type/helper, or a migration (the Impact-Analysis categories) — **strongly suggest** running `/review` (blast-radius tier) before committing, to check the flows that *consume* the changed thing, not just the diff. Offer, never auto-run.
10. Report results: all passed, or list failures/warnings with file paths and error messages.
11. If all checks pass, confirm ready to commit.
