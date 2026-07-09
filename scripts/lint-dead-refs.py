#!/usr/bin/env python3
"""lint-dead-refs.py — kit self-test: find dead cross-references in shipped files.

The rot class the 2026-07-08 kit review found by hand: shipped docs citing
scripts/standards/docs that don't exist. For every manifest-listed markdown
file, extract project-relative path references (ai/…, docs/…, bootstrap/…,
.claude/…, testing-reports/…) and verify each resolves within the union of
all shipped destinations (core + every module — module files may be
referenced from core with an "if applicable" qualifier, so the union is the
right universe).

Skipped references: globs (*), templated parts (<name>, {{TOKEN}}), and
directory refs that exist as a shipped destination prefix.

Kit-dev tool: does not ship. Run from the repo root: python3 scripts/lint-dead-refs.py
"""
import os
import re
import sys

import yaml

ROOT = "template"
PATH_REF = re.compile(r"(?<![\w/.-])((?:ai|docs|bootstrap|\.claude|testing-reports)/[\w./\-*<>{}]*)")


def main() -> int:
    with open(os.path.join(ROOT, "manifest.yml")) as fh:
        manifest = yaml.safe_load(fh)

    sources: dict[str, str] = {}  # on-disk -> destination
    for f in manifest["core"]["files"]:
        sources[os.path.join(ROOT, "core", f)] = f
    for name, mod in manifest["modules"].items():
        for f in mod["files"] or []:
            sources[os.path.join(ROOT, "modules", name, f)] = f

    destinations = set(sources.values())
    dest_dirs = set()
    for d in destinations:
        parts = d.split("/")
        for i in range(1, len(parts)):
            dest_dirs.add("/".join(parts[:i]))

    errors = []
    for path, dest in sorted(sources.items()):
        if not path.endswith((".md", ".sh", ".txt", ".json")) or not os.path.isfile(path):
            continue
        text = open(path, encoding="utf-8").read()
        for n, line in enumerate(text.splitlines(), 1):
            for ref in PATH_REF.findall(line):
                ref = ref.rstrip(".,:;)`'\"")
                if not ref or "*" in ref or "<" in ref or "{" in ref or "NNN" in ref:
                    continue  # glob or templated (incl. NNN id-placeholders) — can't resolve statically
                if re.search(r"e\.g\.", line):
                    continue  # exemplary path ("e.g. docs/runbooks/…"), not a citation
                candidate = ref.rstrip("/")
                if candidate in destinations or candidate in dest_dirs:
                    continue
                errors.append(f"{path}:{n}: dead reference '{ref}' (from shipped file {dest})")

    if errors:
        print("DEAD-REFERENCE LINT FAILED:")
        for e in errors:
            print(f"  - {e}")
        return 1
    print(f"OK: no dead cross-references across {len(sources)} shipped files.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
