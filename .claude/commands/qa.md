Run QA validation against recent changes.

1. Run `git diff --name-only` to identify which areas changed.
2. Read `ai/CHECKLISTS/qa.md` for the full checklist.
3. Run the appropriate test suites for the affected areas:
   - Unit/integration: `bash scripts/selftest.sh`
   - End-to-end (if UI/flow changed): `N/A (no runtime UI)`
4. Run an integrity audit: check for `.only`, skipped tests, or mocked-away security checks in changed test files (see `ai/STANDARDS/TESTING_STANDARD.md`).
5. Verify the acceptance criteria for what changed, in this order:
   - `docs/registers/PRODUCT_REGISTER.md` — the `AC-n` rows for the stories the change touches. These are durable and exist whether or not the reports module is installed; verify each and report outcomes **against the criterion's ID**.
   - The work item's acceptance doc, if one exists — its change-specific criteria.
   - A durable criterion you had to invent to judge the change is a finding: file it to the register, or the next run invents it again.
6. If UI changed, spot-check responsive behavior and loading/empty/error states.
7. Summarize: tests passed/failed, acceptance criteria status, any issues found. **Success is one summary line — no report document.**
8. On failure, write a diagnostic bundle per `ai/TEMPLATES/DIAGNOSTIC_BUNDLE_TEMPLATE.md` into `testing-reports/` (gitignored — never committed).
9. For any issues found, recommend whether to file a tracked issue per `ai/STANDARDS/GITHUB_ISSUES.md`, linking the bundle.
