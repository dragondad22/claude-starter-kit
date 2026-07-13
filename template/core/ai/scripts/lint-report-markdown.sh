#!/usr/bin/env bash
# lint-report-markdown.sh — enforce the table-pipe-escape rule for report markdown.
#
# The rule (single home: ai/TEMPLATES/DIAGNOSTIC_BUNDLE_TEMPLATE.md, TABLE-LINT
# NOTE): inside a markdown table row, a raw `|` within inline code splits the
# cell and silently corrupts the rendered table — use pipe-free wording or
# escape as \|. This script is the meter for that rule.
#
# Usage:
#   bash ai/scripts/lint-report-markdown.sh [file.md ...]
# With no arguments, lints every .md under testing-reports/.

set -euo pipefail

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  echo "Usage: $0 [path ...]   (default: all .md under testing-reports/)"
  exit 0
fi

if [ "$#" -eq 0 ]; then
  set --
  while IFS= read -r f; do
    set -- "$@" "$f"
  done < <(find testing-reports -type f -name '*.md' 2>/dev/null | sort)
fi

if [ "$#" -eq 0 ]; then
  echo "No markdown files found to lint."
  exit 0
fi

awk '
function has_unescaped_pipe_in_code(line,   i,ch,prev,in_code) {
  in_code = 0
  prev = ""
  for (i = 1; i <= length(line); i++) {
    ch = substr(line, i, 1)
    if (ch == "`") {
      in_code = !in_code
    } else if (in_code && ch == "|" && prev != "\\") {
      return 1
    }
    prev = ch
  }
  return 0
}

BEGIN { violations = 0 }

{
  if ($0 ~ /^[[:space:]]*\|/ && has_unescaped_pipe_in_code($0)) {
    printf "%s:%d:%s\n", FILENAME, NR, $0
    violations = 1
  }
}

END {
  if (violations) {
    print "" > "/dev/stderr"
    print "Markdown table lint failed: unescaped | inside inline code in table rows." > "/dev/stderr"
    print "Use pipe-free wording when possible; otherwise escape as \\|." > "/dev/stderr"
    exit 1
  }
}
' "$@"

echo "Markdown table lint passed for $# file(s)."
