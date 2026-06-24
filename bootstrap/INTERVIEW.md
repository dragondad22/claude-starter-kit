# Bootstrap Interview

The question script the `/bootstrap` command works through. Each question maps to
one or more tokens in `PLACEHOLDERS.md`. Detect before asking; confirm defaults
rather than asking blind. Group related questions.

## 1. Identity
- What is the project called? → `{{PROJECT_NAME}}`
- One line: what is it? → `{{PROJECT_TAGLINE}}`
- Who owns it (company / org / you)? → `{{PROJECT_OWNER}}`
- What problem domain is it in, in plain words? → `{{PROJECT_DOMAIN}}`

## 2. Source control & tracking
- Canonical remote? (detect via `git remote -v`) → `{{REPO_SLUG}}`
- Where do tasks live? Tool + URL. → `{{ISSUE_TRACKER}}`, `{{ISSUE_TRACKER_KIND}}`
- Prefix for work-item IDs in reports/branches? (e.g. `IMP`, `TASK`, or the tracker's own keys) → `{{WORK_ITEM_PREFIX}}`

## 3. Stack & layout (detect first, confirm)
- Primary language(s)? → `{{PRIMARY_LANGUAGE}}`
- Top-level repo layout, one paragraph? → `{{APP_LAYOUT}}`
- Commands (read from package.json/Makefile/etc., confirm):
  - Run tests → `{{TEST_COMMAND}}`
  - Build / typecheck → `{{BUILD_COMMAND}}`
  - Start locally → `{{DEV_COMMAND}}`
  - Lint / format (or N/A) → `{{LINT_COMMAND}}`
  - E2E tests (or N/A) → `{{E2E_COMMAND}}`
- Does it have a database? If so, ORM/migration tool + migrate command. (If no → prune DB standard) → `{{DB_LAYER}}`, `{{MIGRATION_COMMAND}}`
- Does it have a UI? (If no → prune UI standard)
- Design source of truth, if any (Figma/none)? → `{{DESIGN_SOURCE}}`

## 4. Docs
- Where do user-facing docs live / what's their source of truth? (a docs site, a README, in-app help, "none yet") → `{{DOCS_SOURCE_OF_TRUTH}}`
- Where do UAT / acceptance docs live? (default `docs/uat/`) → `{{UAT_DOC}}`

## 5. Versioning
- Which files hold a version and must move in lockstep? (default: just `VERSION`) → `{{VERSION_FILES}}`
- Versioning scheme? (default SemVer) → `{{VERSION_SCHEME}}`

## 6. Quality gates
- CI system + key workflow file(s)? (or "none yet") → `{{CI_SYSTEM}}`
- Dependency/security scan command? (e.g. `npm audit`, `pip-audit`, or N/A) → `{{SECURITY_SCAN_COMMAND}}`
- The one performance signal that matters? (e.g. an endpoint p95, cold-start time, or N/A) → `{{PERF_TARGET}}`

## 7. Non-negotiables (most important)
- What architectural constraints must never be re-litigated? Push for at least one real one.
  Prompts to draw them out: security/isolation invariants, data-integrity rules, privacy boundaries,
  idempotency/consistency guarantees, "we will never do X". → `{{NON_NEGOTIABLES}}`
