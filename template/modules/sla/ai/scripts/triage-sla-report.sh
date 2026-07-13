#!/usr/bin/env bash
# triage-sla-report.sh — SLA-breach snapshot for open quality findings (sla module).
#
# Backs ai/STANDARDS/ISSUE_SLA_STANDARD.md with an operational check: lists every
# open issue carrying a quality-report label, its age, its first-response window,
# and whether the clock is blown. Run it at triage review, or wire it into CI on
# a schedule.
#
# GitHub-tracker specific (gh + jq required); other trackers: reimplement the
# same query against your tracker's API, keeping the label names and windows
# aligned with the SLA standard.
#
# The response windows below are DAYS and must agree with the "First triage
# response" column in ai/STANDARDS/ISSUE_SLA_STANDARD.md — that table is the
# commitment; this script is only the meter. Override per-run via env if the
# standard changes faster than this file (then update the defaults!).

set -euo pipefail

command -v gh >/dev/null 2>&1 || { echo "ABORT: gh is required" >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "ABORT: jq is required" >&2; exit 1; }

SLA_DAYS_BLOCKER="${SLA_DAYS_BLOCKER:-0}"   # same business day
SLA_DAYS_HIGH="${SLA_DAYS_HIGH:-1}"
SLA_DAYS_MEDIUM="${SLA_DAYS_MEDIUM:-3}"
SLA_DAYS_LOW="${SLA_DAYS_LOW:-5}"
SLA_DAYS_UNSPECIFIED="${SLA_DAYS_UNSPECIFIED:-3}" # unlabeled severity = medium until triaged

OUT="$(gh issue list --state open --limit 200 --json number,title,createdAt,url,labels | jq -r \
  --argjson b "$SLA_DAYS_BLOCKER" --argjson h "$SLA_DAYS_HIGH" \
  --argjson m "$SLA_DAYS_MEDIUM" --argjson l "$SLA_DAYS_LOW" \
  --argjson u "$SLA_DAYS_UNSPECIFIED" '
  def has_quality_label: any(.labels[]?.name; . == "testing" or . == "uat" or . == "security-review" or . == "performance");
  def severity_from_issue:
    if any(.labels[]?.name; . == "severity:blocker") then "Blocker"
    elif any(.labels[]?.name; . == "severity:high") then "High"
    elif any(.labels[]?.name; . == "severity:medium") then "Medium"
    elif any(.labels[]?.name; . == "severity:low") then "Low"
    elif (.title | test("\\[Blocker\\]"; "i")) then "Blocker"
    elif (.title | test("\\[High\\]"; "i")) then "High"
    elif (.title | test("\\[Medium\\]"; "i")) then "Medium"
    elif (.title | test("\\[Low\\]"; "i")) then "Low"
    else "Unspecified"
    end;
  def sla_days:
    if . == "Blocker" then $b
    elif . == "High" then $h
    elif . == "Medium" then $m
    elif . == "Low" then $l
    else $u
    end;
  ["Issue","Severity","AgeDays","SLA(days)","Status","URL"],
  (.[]
    | select(has_quality_label)
    | .severity = severity_from_issue
    | .age_days = (((now - (.createdAt | fromdateiso8601)) / 86400) | floor)
    | .sla_days = (.severity | sla_days)
    | .status = (if .age_days > .sla_days then "BREACH" else "OK" end)
    | ["#\(.number)", .severity, (.age_days|tostring), (.sla_days|tostring), .status, .url])
  | @tsv')"

if command -v column >/dev/null 2>&1; then
  printf '%s\n' "$OUT" | column -t -s "$(printf '\t')"
else
  printf '%s\n' "$OUT"
fi

printf '%s\n' "$OUT" | tail -n +2 | grep -q "BREACH" && exit 2 || exit 0
