#!/usr/bin/env python3
"""lint-currency.py — kit self-test: the docs still describe the kit that exists.

The rot class the 2026-08-03 staleness sweep found by hand (epic #172): every
check the kit already had verifies that shipped files are *consistent*
(manifest complete, cross-references resolve, the scaffold runs). None verify
that the prose still *describes* what ships. So a module can be added, a
command shipped, or a standard rewritten, and every hand-maintained
enumeration silently rots — epic #145 did exactly that four PRs in a row.

Why it matters more here than in an ordinary repo: the kit seeds every
downstream project. A wrong `Last Updated` is copied outward and believed by a
reader who holds only that copy and has no history to check it against.

Four checks, every expectation derived from what is on disk or in the
manifest — never from a second list that could itself rot:

  1. every shipped standard carries a `Last Updated:` line
  2. no `Last Updated:` predates its file's last *content* change
     (commits that touch only the date line are ignored — otherwise the PR
     that introduced the field would make every date look stale)
  3. every module in manifest.yml appears in each module enumeration
  4. every shipped slash command appears in each command enumeration

Why this still exists alongside `/evergreen` (T36.8 reconciliation): the
date-sweep and standards-drift lenses ask a human-or-model to *judge* currency on
a ~30-day cadence; this fails a PR mechanically, today, with no judgment
involved. They compose — the lens catches what needs reading (is this rule still
right?), the linter catches what needs counting (is this list complete, is this
date a lie?). Neither replaces the other, and the linter is the one that would
have stopped epic #145.

Kit-dev tool: does not ship, so it is exempt from the T2 portable-shell rule.
Needs full git history — in CI, checkout with `fetch-depth: 0`.

Run from the repo root: python3 scripts/lint-currency.py
"""
import os
import re
import subprocess
import sys

import yaml

ROOT = "template"
DATE_LINE = re.compile(r"^Last Updated:\s*(\d{4}-\d{2}-\d{2})\s*$", re.M)
PAREN_LIST = re.compile(r"\(([^()]*)\)")
SLASH_CMD = re.compile(r"/([a-z][a-z-]*)")

# Files that must enumerate every module. Named explicitly so the check is
# targeted rather than guessing at prose.
#
# Two strengths, because these files enumerate differently. Every listed file
# must at least *mention* every module (catches a module added with no doc
# update anywhere). Where a file also carries a parenthesised list — the form
# that rots most quietly, since it reads as complete — that list must be
# complete too. README.md enumerates as an indented tree, so only the mention
# check applies there.
MODULE_ENUMERATIONS = [
    "template/core/docs/kit/WORKFLOW.md",
    "CLAUDE.md",
    "README.md",
]

# Files that must mention every shipped slash command.
COMMAND_ENUMERATIONS = [
    "template/core/docs/kit/README.md",
    "README.md",
]


def git(*args: str) -> str:
    return subprocess.run(["git", *args], capture_output=True, text=True).stdout.strip()


def last_content_change(path: str) -> tuple[str, str] | None:
    """(date, sha) of the newest commit that changed more than the date line."""
    for sha in git("log", "--format=%H", "--", path).split():
        diff = git("show", "--format=", "--unified=0", sha, "--", path)
        for line in diff.splitlines():
            if not line.startswith(("+", "-")) or line.startswith(("+++", "---")):
                continue
            body = line[1:].strip()
            if not body or body.startswith("Last Updated:"):
                continue
            return git("show", "-s", "--format=%ad", "--date=short", sha), sha
    return None


def main() -> int:
    if git("rev-parse", "--is-shallow-repository") == "true":
        print("FAIL: shallow clone — the date check needs history.")
        print("      In CI: actions/checkout@v4 with `fetch-depth: 0`.")
        return 1

    with open(os.path.join(ROOT, "manifest.yml")) as fh:
        manifest = yaml.safe_load(fh)
    modules = set(manifest["modules"])

    problems: list[str] = []

    # --- 1 & 2: Last Updated present, and not older than the content ---------
    standards = sorted(
        os.path.join(dirpath, f)
        for dirpath, _, files in os.walk(ROOT)
        if os.path.basename(dirpath) == "STANDARDS"
        for f in files
        if f.endswith(".md")
    )
    if not standards:
        problems.append("no shipped standards found — is this the repo root?")

    for path in standards:
        with open(path) as fh:
            text = fh.read()
        match = DATE_LINE.search(text)
        if not match:
            problems.append(
                f"{path}: no `Last Updated:` line.\n"
                f"    Add `Last Updated: YYYY-MM-DD` immediately after the `#` title.\n"
                f"    Rule: template/core/ai/STANDARDS/DOCUMENTATION_STANDARD.md"
            )
            continue
        stated = match.group(1)
        actual = last_content_change(path)
        if actual and stated < actual[0]:
            problems.append(
                f"{path}: `Last Updated: {stated}` is older than its last content change "
                f"({actual[0]}, {actual[1][:8]}).\n"
                f"    Bump it to {actual[0]} or later. A stale date is read as current by "
                f"someone holding a distributed copy."
            )

    # --- 3: module enumerations --------------------------------------------
    for path in MODULE_ENUMERATIONS:
        with open(path) as fh:
            text = fh.read()

        unmentioned = {m for m in modules if not re.search(rf"\b{re.escape(m)}\b", text)}
        if unmentioned:
            problems.append(
                f"{path}: never mentions module(s) {sorted(unmentioned)}.\n"
                f"    Every module in template/manifest.yml must appear here."
            )

        for n, line in enumerate(text.splitlines(), 1):
            for inner in PAREN_LIST.findall(line):
                listed = {t.strip().strip("`*_") for t in inner.split(",")}
                if len(listed & modules) < 2:
                    continue
                missing = modules - listed
                if missing:
                    problems.append(
                        f"{path}:{n}: parenthesised module list is missing {sorted(missing)}.\n"
                        f"    Found: ({inner})\n"
                        f"    A partial list reads as complete — every module must appear."
                    )

    # --- 4: command enumerations -------------------------------------------
    commands = {
        os.path.splitext(f)[0]
        for dirpath, _, files in os.walk(ROOT)
        if dirpath.endswith(os.path.join(".claude", "commands"))
        for f in files
        if f.endswith(".md")
    }
    for path in COMMAND_ENUMERATIONS:
        with open(path) as fh:
            mentioned = set(SLASH_CMD.findall(fh.read()))
        missing = commands - mentioned
        if missing:
            problems.append(
                f"{path}: no mention of {sorted('/' + c for c in missing)}.\n"
                f"    Every shipped .claude/commands/*.md must appear here."
            )

    if problems:
        print(f"FAIL: {len(problems)} currency problem(s) — the docs no longer "
              f"describe what ships.\n")
        for p in problems:
            print(f"  - {p}")
        return 1

    print(
        f"OK: currency verified — {len(standards)} standards dated and current, "
        f"{len(modules)} modules and {len(commands)} commands enumerated everywhere."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
