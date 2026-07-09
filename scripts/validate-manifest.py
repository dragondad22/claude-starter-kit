#!/usr/bin/env python3
"""validate-manifest.py — kit self-test: validate template/manifest.yml (T23.2).

Checks:
  1. Every manifest-listed file exists on disk.
  2. Every file under template/core and template/modules is either
     manifest-listed or known kit metadata (module READMEs, template README,
     the manifest itself) — the allowlist stays complete.
  3. No shipped (manifest-listed) file references a kit-dev path
     (template/…, docs/plans/<kit decision records>, scripts/, test/…).

Kit-dev tool: does not ship. Run from the repo root: python3 scripts/validate-manifest.py
"""
import os
import re
import sys

import yaml

ROOT = "template"
KIT_METADATA = re.compile(r"^template/(README\.md|manifest\.yml|modules/[^/]+/README\.md)$")
# Kit-dev path patterns that must never appear inside shipped files.
KIT_DEV_REF = re.compile(
    r"template/(core|modules|manifest)"
    r"|docs/plans/\d{4}-\d{2}-\d{2}-"   # kit decision records (dated plan files)
    r"|(?<![\w/.-])scripts/[a-z-]+\.(py|sh)"  # root kit-dev scripts/ (not ai/scripts/)
    r"|test/fixtures/"
)


def main() -> int:
    with open(os.path.join(ROOT, "manifest.yml")) as fh:
        manifest = yaml.safe_load(fh)

    listed: dict[str, str] = {}  # on-disk path -> destination path
    for f in manifest["core"]["files"]:
        listed[os.path.normpath(os.path.join(ROOT, "core", f))] = f
    for name, mod in manifest["modules"].items():
        for f in mod["files"] or []:
            listed[os.path.normpath(os.path.join(ROOT, "modules", name, f))] = f

    errors = []

    # 1. Every listed file exists.
    for path in listed:
        if not os.path.isfile(path):
            errors.append(f"manifest lists missing file: {path}")

    # 2. Every file in template/ is listed or known metadata.
    for dirpath, _, files in os.walk(ROOT):
        for f in files:
            path = os.path.normpath(os.path.join(dirpath, f))
            if path not in listed and not KIT_METADATA.match(path.replace(os.sep, "/")):
                errors.append(f"unlisted file in template/ (add to manifest or metadata allowlist): {path}")

    # 3. No shipped file references a kit-dev path.
    for path in listed:
        if not os.path.isfile(path):
            continue
        try:
            text = open(path, encoding="utf-8").read()
        except UnicodeDecodeError:
            continue
        for n, line in enumerate(text.splitlines(), 1):
            if KIT_DEV_REF.search(line):
                errors.append(f"shipped file references kit-dev path: {path}:{n}: {line.strip()}")

    if errors:
        print("MANIFEST VALIDATION FAILED:")
        for e in errors:
            print(f"  - {e}")
        return 1
    print(f"OK: manifest valid — {len(listed)} shipped files, allowlist complete, no kit-dev leaks.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
