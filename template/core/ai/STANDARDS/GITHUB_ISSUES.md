*Generic standard from the Claude starter kit — adapt to this project. Replace `{{TOKENS}}`; see `bootstrap/PLACEHOLDERS.md`.*

# Quality Issue Standard for Quality Agents

> This standard is written assuming **GitHub Issues** (`gh` CLI). The structure —
> severity model, title format, body fields, label mapping — ports cleanly to any
> tracker (`{{ISSUE_TRACKER_KIND}}`); replace the `gh` commands with the
> equivalent for your tracker (`{{ISSUE_TRACKER}}`).

## Purpose
Standardize how testing/UAT/security/performance findings become actionable,
tracked issues.

## Preconditions
- Issue tracker access configured (`{{ISSUE_TRACKER}}`).
- For GitHub: CLI installed (`gh --version`), authenticated (`gh auth status`),
  in repo root with remote configured.

## Required Labels

The label taxonomy has one source of truth: the manifest table in
`ai/scripts/bootstrap-labels.sh` (applied idempotently at bootstrap; re-run it
any time labels drift). Do not maintain label lists here or anywhere else.

A quality finding carries:
- `type:bug` — the kind label (exactly one `type:*` per issue)
- one `severity:*` label — how bad the impact is
- one flow label (`testing`, `uat`, `security-review`, `performance`) — which
  quality flow produced the finding
- optional secondary flow labels (`flaky-test`, `coverage-gap`, `ux`,
  `accessibility`, `documentation`)

Severity is for findings; **priority** (`priority:*`) is for planned work
(tasks/features/epics — see `TASK_ISSUE_STANDARD.md`). The split is deliberate:
"how bad is it" and "how soon do we do it" are different questions — don't
unify the two scales.

## Severity Mapping
- `Blocker`: broken core flow, security boundary failure, data integrity risk
- `High`: acceptance criteria failure in major workflow, reproducible failing suite
- `Medium`: non-blocking functional defect, significant UX confusion
- `Low`: copy polish, minor visual inconsistency, non-critical enhancement

## Duplicate Check
Before opening a new issue (GitHub):
```bash
gh issue list --state open --search "<short phrase> in:title"
```
If a duplicate exists, link the existing issue in the report instead of creating
a new one.

## Title Format
Use `{{WORK_ITEM_PREFIX}}-XXX` for the work-item ID (e.g. `IMP-006`).
- TESTER: `[TEST][{{WORK_ITEM_PREFIX}}-XXX][Severity] Short summary`
- UAT: `[UAT][{{WORK_ITEM_PREFIX}}-XXX][Severity] Short summary`
- SECURITY REVIEWER: `[SEC][{{WORK_ITEM_PREFIX}}-XXX][Severity] Short summary`
- PERFORMANCE SMOKE: `[PERF][{{WORK_ITEM_PREFIX}}-XXX][Severity] Short summary`

## Required Issue Body Fields
- Environment
- Build/SHA
- Steps to reproduce
- Expected behavior
- Actual behavior
- Evidence (artifact paths, screenshots, logs)
- Impact
- Suggested fix direction (no direct code patch in issue body)

## CLI Example (GitHub)
```bash
gh issue create \
  --title "[TEST][IMP-006][High] OTP suite intermittently fails on lockout boundary" \
  --label "type:bug,severity:high,testing,flaky-test" \
  --body-file /tmp/issue.md
```

## Report Linking Rule
Every created issue must be linked in the corresponding report under `Issues
Created` with severity and area.

## Triage
- Every new issue must include `type:bug`, one severity label, and one flow
  label (`testing`, `uat`, `security-review`, or `performance`).

## Other Rules
- Never use backticks in issue comments.
