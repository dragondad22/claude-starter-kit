#!/usr/bin/env python3
"""self-conform.py — derive and verify the kit's own installed instance (T36).

This repo is both the product and an adopter of it. `template/` is the product;
the root `ai/`, `.claude/`, `docs/` are this project's installed instance. The
instance is **derived, never authored**: it equals the template at the pinned
release, with this project's placeholder answers filled and the genericization
banner stripped.

Pinned to the last *release*, not HEAD (T36.4). That lag is deliberate — it is
what makes each release a real self-upgrade, exercising the one part of the
upgrade path no test covers: declared adaptations colliding with upstream
changes. Between releases the kit works against last-released standards, exactly
as an adopter does.

Deliberate divergence is legal only when declared in ADAPTATIONS.md with a
reason. The adaptation count is reported on every run so growth stays visible
rather than becoming a quiet dumping ground.

Modes:
  --check   verify the instance matches (exit 1 on drift) — what CI runs
  --apply   rewrite the instance from the pinned template (the upgrade action)

Kit-dev tool: does not ship, so it is exempt from the T2 portable-shell rule.
Needs git history for the pinned tag. Run from the repo root.
"""
import argparse
import os
import re
import subprocess
import sys

import yaml

BANNER = re.compile(r'^\*(?:Generic|Optional)[^\n]*from the Claude starter kit[^\n]*\*\n', re.M)
MODULE_NOTE = re.compile(r'^\*Optional — installed with the [^\n]*\*\n', re.M)
TOKEN = re.compile(r'\{\{([A-Z0-9_]+)\}\}')          # digits matter: E2E_COMMAND
META = {'TOKEN', 'TOKENS', 'PLACEHOLDER', 'DOUBLE_BRACE', 'DATE', 'IMP_ID', 'NON_NEGOTIABLES'}


def git(*args):
    r = subprocess.run(['git', *args], capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else None


def pinned_version():
    with open('bootstrap/KIT_VERSION') as fh:
        for line in fh:
            if line.startswith('kit_version:'):
                return line.split(':', 1)[1].strip()
    sys.exit('FAIL: bootstrap/KIT_VERSION has no kit_version line')


def transform(text, answers, rel):
    """template source -> instance content: fill answers, strip the banner.

    `bootstrap/**` keeps its tokens: those files *document* the placeholder
    system, which is why VERIFY_IGNORE excludes them from the verify grep.
    Filling them would rewrite the documentation to describe one project.
    """
    text = MODULE_NOTE.sub('', BANNER.sub('', text))
    text = re.sub(r'\A\n+', '', text)
    if rel.startswith('bootstrap/'):
        return text
    return TOKEN.sub(lambda m: answers.get(m.group(1), m.group(0))
                     if m.group(1) not in META else m.group(0), text)


def load_adaptations():
    """path -> reason, from the declared list."""
    out = {}
    if not os.path.exists('ADAPTATIONS.md'):
        return out
    with open('ADAPTATIONS.md') as fh:
        for line in fh:
            m = re.match(r'^\|\s*`([^`]+)`\s*\|\s*(.+?)\s*\|\s*$', line)
            if m:
                out[m.group(1)] = m.group(2)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--check', action='store_true', help='verify only; exit 1 on drift')
    ap.add_argument('--apply', action='store_true', help='rewrite the instance from the pin')
    args = ap.parse_args()
    if args.check == args.apply:
        sys.exit('FAIL: pass exactly one of --check / --apply')

    version = pinned_version()
    ref = f'v{version}'
    if git('rev-parse', '--verify', f'{ref}^{{commit}}') is None:
        sys.exit(f'FAIL: pinned release tag {ref} not found. '
                 f'Fetch tags, or fix bootstrap/KIT_VERSION.')

    manifest = git('show', f'{ref}:template/manifest.yml')
    if manifest is None:
        sys.exit(f'FAIL: cannot read template/manifest.yml at {ref}')
    core = yaml.safe_load(manifest)['core']['files']

    with open('scripts/self-answers.yml') as fh:
        answers = {k: str(v) for k, v in yaml.safe_load(fh).items()}

    adaptations = load_adaptations()
    drift, applied, skipped = [], 0, 0

    for rel in core:
        if rel in adaptations:
            skipped += 1
            continue
        src = git('show', f'{ref}:template/core/{rel}')
        if src is None:
            drift.append(f'{rel}: missing from template at {ref} — stale manifest?')
            continue
        want = transform(src, answers, rel)
        have = open(rel).read() if os.path.exists(rel) else None

        if args.apply:
            if have != want:
                os.makedirs(os.path.dirname(rel) or '.', exist_ok=True)
                with open(rel, 'w') as fh:
                    fh.write(want)
                applied += 1
        elif have is None:
            drift.append(f'{rel}: missing from the instance — run --apply')
        elif have != want:
            drift.append(f'{rel}: differs from template@{ref}. '
                         f'Fix template/ and re-run --apply, or declare it in ADAPTATIONS.md')

    if args.apply:
        print(f'OK: instance conformed to template@{ref} — {applied} file(s) rewritten, '
              f'{skipped} declared adaptation(s) left alone.')
        return 0

    if drift:
        print(f'FAIL: {len(drift)} file(s) diverge from template@{ref} without a declared '
              f'adaptation.\n')
        for d in drift:
            print(f'  - {d}')
        print('\n  The instance is derived, never authored: change template/ and re-run '
              '`python3 scripts/self-conform.py --apply`.')
        return 1

    print(f'OK: instance conformant with template@{ref} — {len(core) - skipped} file(s) verified, '
          f'{skipped} declared adaptation(s).')
    return 0


if __name__ == '__main__':
    sys.exit(main())
