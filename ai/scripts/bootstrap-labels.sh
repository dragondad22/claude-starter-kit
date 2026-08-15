#!/usr/bin/env bash
# bootstrap-labels.sh — Apply the project's issue-label taxonomy, idempotently.
#
# THE TABLE BELOW IS THE LABEL MANIFEST — the single source of truth for the
# whole taxonomy. The issue standards (ai/STANDARDS/GITHUB_ISSUES.md,
# ai/STANDARDS/TASK_ISSUE_STANDARD.md) point here instead of carrying their
# own label lists. Change labels here, re-run, done.
#
# Taxonomy (rationale in ai/STANDARDS/GITHUB_ISSUES.md):
#   type:*      kind of work item — exactly one per issue (epic/feature/task/bug)
#   area:*      functional area — PROJECT-DEFINED; edit that section at bootstrap
#   priority:*  planned work (type:epic/feature/task) — how soon it matters
#   severity:*  quality findings (type:bug) — how bad the impact is
#   flow labels quality findings only — which quality flow produced the finding
#
# Idempotent: `gh label create --force` creates the label or updates the
# color/description of an existing one. Safe to re-run any time.
# Nothing is ever deleted — a label outside the table is left alone.
#
# Usage: ai/scripts/bootstrap-labels.sh [--dry-run|--check]
#   --dry-run  print the labels that would be applied, change nothing
#   --check    report table labels missing from the tracker; exit 1 if any are
#
# `--check` exists because this table grows. A label added here reaches the
# tracker only when someone re-runs the script, and nothing prompts that — so
# the taxonomy the standards promise drifts out of existence silently, and a
# bug filed without its `severity:*` label is untriaged by the project's own
# rule. Wire --check into CI so the drift is caught rather than remembered.
#
# Requires: gh CLI, authenticated, run from the repo root (or any repo dir).
# Non-GitHub trackers: treat the table as the canonical list and mirror it
# with your tracker's label/tag tooling.

set -euo pipefail

MODE=apply
case "${1:-}" in
  '')        ;;
  --dry-run) MODE=dry ;;
  --check)   MODE=check ;;
  *) echo "usage: $0 [--dry-run|--check]" >&2; exit 2 ;;
esac
DRY_RUN=0
[ "$MODE" = dry ] && DRY_RUN=1

# label|color|description   (color = 6-hex, no leading #)
#
# Quoted heredoc, not a single-quoted string: descriptions are prose, and prose
# contains apostrophes. Inside 'LABELS=...' one apostrophe closes the string and
# the rest of the table becomes shell code — it fails at assignment, before any
# label is touched, with an error naming a word from a comment. <<'EOF' makes
# every character literal, so the table stays a table.
LABELS=$(cat <<'LABEL_TABLE'
# --- type:* — kind, exactly one per issue ---------------------------------
type:epic|3E4B9E|Epic: parent issue grouping features/tasks via sub-issues
type:feature|A2EEEF|Feature: user-visible capability, usually under an epic
type:task|0075CA|Implementation task
type:bug|D73A4A|Defect in existing behavior

# --- area:* — PROJECT-DEFINED. This repo's areas, not the shipped api/web/infra
# examples: the kit has two trees (T36), and which one a change touches is the
# distinction worth labelling. Declared in ADAPTATIONS.md.
area:kit-dev|BFD4F2|Kit development: this repo's own tooling, tests, CI and records — never ships
area:template|BFD4F2|Shipped content under template/ — reaches every adopter
area:process|BFD4F2|How work is done here: standards, workflow, decisions, release identity

# --- priority:* — planned work (epics/features/tasks) ---------------------
priority:critical|B60205|Blocks real-world use or is a security/data boundary gap
priority:high|D93F0B|Degrades feature completeness significantly
priority:medium|FBCA04|Noticeable gap but workaround exists
priority:low|C2E0C6|Polish or nice-to-have

# --- severity:* — quality findings (bugs) ---------------------------------
severity:blocker|B60205|Broken core flow, security boundary failure, data integrity risk
severity:high|D93F0B|Acceptance criteria failure in major workflow
severity:medium|FBCA04|Non-blocking functional defect
severity:low|C2E0C6|Copy polish, minor visual inconsistency

# --- release membership ---------------------------------------------------
# Release scope itself is the milestone, never a label (ai/STANDARDS/RELEASE_STANDARD.md).
# This is the one exception, and it labels the opposite: an item deliberately OUT
# of every milestone until a named event fires. Without it a dormant commitment is
# indistinguishable from an abandoned one, because nobody greps issue bodies.
triggered|5319E7|Dormant commitment: out until the event named in its body fires

# --- flow labels — quality findings only: which flow produced it ----------
testing|0E8A16|Automated testing findings
uat|1D76DB|UAT findings
security-review|D93F0B|Security reviewer findings
performance|0E8A16|Performance smoke findings
flaky-test|B60205|Flaky or nondeterministic tests
coverage-gap|FBCA04|Missing critical test coverage
ux|5319E7|UX quality issue
accessibility|0052CC|Accessibility issue
documentation|006B75|Documentation drift

# --- process labels --------------------------------------------------------
evergreen|7057FF|Standards & process evergreening review (/evergreen findings)
LABEL_TABLE
)

if [ "$MODE" != dry ]; then
  command -v gh >/dev/null 2>&1 || {
    [ "$MODE" = check ] && { echo "SKIPPED: gh CLI not found — cannot check labels."; exit 0; }
    echo "ABORT: gh CLI not found — install it or mirror the table by hand." >&2
    exit 1
  }
  gh auth status >/dev/null 2>&1 || {
    [ "$MODE" = check ] && { echo "SKIPPED: gh is not authenticated — cannot check labels."; exit 0; }
    echo "ABORT: gh is not authenticated (run: gh auth login)." >&2
    exit 1
  }
fi

# --check reads the tracker once, then tests membership per row. An unreachable
# tracker is a skip, not a failure: the check is a guard against drift, and
# failing a whole suite because the network is down helps nobody.
EXISTING=''
if [ "$MODE" = check ]; then
  EXISTING=$(gh label list --limit 300 --json name --jq '.[].name' 2>/dev/null) || {
    echo "SKIPPED: could not list labels (no repo context, or the API is unreachable)."
    exit 0
  }
fi

case "$MODE" in
  dry)   echo "=== Label bootstrap (dry run) ===" ;;
  check) echo "=== Label check ===" ;;
  *)     echo "=== Label bootstrap ===" ;;
esac

applied=0
missing=0
# while-read over a heredoc: stock macOS ships bash 3.2, which lacks mapfile.
while IFS='|' read -r name color desc; do
  # skip blanks and comment rows
  case "$name" in ''|\#*) continue ;; esac
  case "$MODE" in
    dry)
      printf '  %-20s #%s  %s\n' "$name" "$color" "$desc"
      ;;
    check)
      # newline-delimited containment: portable, and exact rather than substring,
      # so `ux` does not match `uxr` and `type:bug` does not match `type:bugfix`.
      case "
$EXISTING
" in
        *"
$name
"*) : ;;
        *) printf '  MISSING: %-20s (%s)\n' "$name" "$desc"; missing=$((missing + 1)) ;;
      esac
      ;;
    *)
      gh label create "$name" --color "$color" --description "$desc" --force
      printf '  applied: %s\n' "$name"
      ;;
  esac
  applied=$((applied + 1))
done <<EOF
$LABELS
EOF

echo ""
if [ "$MODE" = check ]; then
  if [ "$missing" -gt 0 ]; then
    echo "FAIL: $missing of $applied table labels are missing from the tracker." >&2
    echo "      Run: ai/scripts/bootstrap-labels.sh" >&2
    exit 1
  fi
  echo "OK: all $applied table labels exist in the tracker."
else
  echo "OK: $applied labels $([ "$DRY_RUN" -eq 1 ] && echo 'listed' || echo 'created/updated')."
fi
