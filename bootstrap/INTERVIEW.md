# Bootstrap Token Map

The token-fill map `/bootstrap` works through as **the final step of inception**
(the deep questions live in `bootstrap/QUESTION_BANK.md`; format in
`ai/STANDARDS/INTERVIEW_STANDARD.md`). Each entry maps one or more
`PLACEHOLDERS.md` tokens to the question that answers it — fill from the
inception interview's `Final:` fields first, detect what's mechanical
(commands, stack), and only ask in chat for what neither covers. Confirm
defaults rather than asking blind; group related questions.

## 1. Identity
- What is the project called? → `Claude Starter Kit`
- One line: what is it? → `A stack-agnostic starter kit for working on projects with Claude Code`
- Who owns it (company / org / you)? → `Chris (dragondad22)`
- What problem domain is it in, in plain words? → `AI-assisted software development process`

## 2. Source control & tracking
- Where do tasks live? Tool + URL. → `https://github.com/dragondad22/claude-starter-kit/issues`, `GitHub Issues`
- Prefix for work-item IDs in reports/branches? (e.g. `IMP`, `TASK`, or the tracker's own keys) → `KIT`

## 3. Stack & layout (detect first, confirm)
- Primary language(s)? → `Markdown (the product) + POSIX shell and Python 3 (tooling)`
- Top-level repo layout, one paragraph? → `template/ is the shipped product; scripts/, docs/plans/ and .github/ are kit development`
- Commands (read from package.json/Makefile/etc., confirm):
  - Run tests → `bash scripts/selftest.sh`
  - Build / typecheck → `N/A (no build step)`
  - Start locally → `N/A (no runtime)`
  - Lint / format (or N/A) → `bash -n scripts/*.sh`
  - E2E tests (or N/A) → `{{E2E_COMMAND}}`
- Does it have a database? If so, ORM/migration tool + migrate command. (If no → prune DB standard) → `N/A`, `N/A`
- Does it have a UI? (If no → prune UI standard)
- Design source of truth, if any (Figma/none)? → `none`

## 4. Docs
- Where do user-facing docs live / what's their source of truth? (a docs site, a README, in-app help, "none yet") → `README.md, plus the shipped guide in template/core/docs/kit/`
- Where do UAT / acceptance docs live? (default `docs/uat/`) → `N/A (reports module not installed)`

## 5. Versioning
- Which files hold a version and must move in lockstep? (default: just `VERSION`) → `VERSION`
- Versioning scheme? (default SemVer) → `SemVer (pre-1.0)`

## 6. Quality gates
- CI system + key workflow file(s)? (or "none yet") → `GitHub Actions (.github/workflows/kit-selftest.yml)`
- Dependency/security scan command? (e.g. `npm audit`, `pip-audit`, or N/A) → `N/A (no third-party dependencies)`
- The one performance signal that matters? (e.g. an endpoint p95, cold-start time, or N/A) → `N/A`

## 7. Platforms, audience & compliance
These drive `ai/STANDARDS/EXTERNAL_STANDARDS_AND_COMPLIANCE.md` and seed `docs/compliance/COMPLIANCE_REGISTER.md`.
- What platforms ship? (web / iOS / Android / desktop / API-only / CLI) → `macOS + Linux developer machines (stock bash 3.2)`
- Who's the audience, and does it include minors? If so, what age range? → `developers using Claude Code, general adult`
- What regulated/sensitive data does it handle? (PII, health, payments, location, none) → `none`
- Any obligation-bearing features? (user-to-user messaging, UGC, payments, tracking/analytics, public API consumed by others) → `none (MIT open-source distribution)`
- After collecting these, walk the trigger map and pre-populate the register's "Active obligations" with the rows that fire (mark each ☐ with today's date as Verified). The 14+/messaging worked example in the register shows the shape.

## 8. Non-negotiables (most important)
- What architectural constraints must never be re-litigated? Push for at least one real one.
  Prompts to draw them out: security/isolation invariants, data-integrity rules, privacy boundaries,
  data/compute locality (incl. third-party AI services — see the interview's Q-INFRA-04),
  idempotency/consistency guarantees, "we will never do X". → `{{NON_NEGOTIABLES}}`
