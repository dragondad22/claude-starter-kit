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

Deliberate divergence is legal only when declared in ADAPTATIONS.md, which has
two tables: **adapted** (the shipped file is wrong for this project — content
not checked, the row carries the reason) and **seeded** (a starting skeleton the
project is meant to fill, such as a rolling log or registry — existence checked,
content not). The declared count prints on every run so growth stays visible
rather than becoming a quiet dumping ground.

Which files are *seeded* is a property of the product, so it is declared in
`template/manifest.yml`; ADAPTATIONS.md says what this instance keeps in each.
Every mode checks the two agree before touching anything, because a seeded file
missing its row is a file `--apply` will silently overwrite (#262, seen in #244).

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

# Two banner forms ship: an italic line on standards/commands, and an HTML
# comment on templates and seeded docs (invisible when rendered). Both mark a
# file as not-yet-adapted, so both are stripped — missing the second left three
# derived files carrying a banner the /evergreen drift lens would flag.
BANNER = re.compile(
    r'^(?:\*(?:Generic|Optional)[^\n]*from the Claude starter kit[^\n]*\*'
    r'|<!--\s*(?:Generic|Optional)[^\n]*from the Claude starter kit[^\n]*-->)\n', re.M)
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


def load_declared():
    """(adapted, seeded) -> {path: reason}, read from the two ADAPTATIONS.md tables.

    Two kinds of legal divergence, and conflating them was a real bug:

    - **adapted** — the shipped file is wrong for this project, so the instance
      keeps its own version. Content is *not* checked; the row carries the reason.
    - **seeded** — the shipped file is a starting skeleton the project is meant to
      fill (rolling logs, registries, decision records). Divergence is the file
      doing its job, so only *existence* is checked. Without this, every log entry
      would need an adaptation row and the list would stop meaning anything.
    """
    adapted, seeded, table = {}, {}, 'adapted'   # rows before any heading are adaptations
    if not os.path.exists('ADAPTATIONS.md'):
        return adapted, seeded
    with open('ADAPTATIONS.md') as fh:
        for line in fh:
            low = line.lower()
            if low.startswith('## '):
                table = 'seeded' if 'seeded' in low else 'adapted'
            m = re.match(r'^\|\s*`([^`]+)`\s*\|\s*(.+?)\s*\|\s*$', line)
            if m:
                (seeded if table == 'seeded' else adapted)[m.group(1)] = m.group(2)
    return adapted, seeded


def validate_classification():
    """Errors for every seeded file the product declares and this instance has not classified.

    The failure this prevents (#262, seen for real in #244): a founding doc
    ships, nobody adds a row here, and `--apply` re-derives it — replacing the
    project's recorded answers with the generic skeleton. It is silent by
    construction, because rewriting a file is exactly what `--apply` is *for*;
    nothing distinguishes "correctly re-derived a generic file" from "destroyed
    this project's answers".

    Before this check the classification had no authority: `seeded` was asserted
    in ADAPTATIONS.md and nowhere else, so there was nothing to check it against
    and a founding doc was classified only if a human remembered. The authority
    now sits in `template/manifest.yml`, where the file is already being
    declared to ship at all (T23.2) — so the reminder arrives at a step the
    author cannot skip.

    Read from the **working tree**, deliberately, while the conformance loop
    below reads the manifest at the pin. A seeded file added this release is not
    in the pinned manifest, so a pin-scoped check would stay quiet until the
    next release — which is one `--apply` too late. This fires in the PR that
    adds the file.
    """
    with open('template/manifest.yml') as fh:
        head = yaml.safe_load(fh)
    seeded_product = set(head.get('seeded') or [])
    core_head = set(head['core']['files'])
    adapted, seeded = load_declared()

    errors = []
    # Only core files reach the instance: a module's seeded files matter once
    # that module is installed, and this repo installs none.
    for rel in sorted(seeded_product & core_head):
        if rel in seeded or rel in adapted:
            continue
        errors.append(
            f'{rel}: shipped as a SEEDED file but classified nowhere in ADAPTATIONS.md.\n'
            f'      --apply would overwrite this project\'s content with the generic\n'
            f'      skeleton. Add it under "## Seeded", with why it is seeded:\n'
            f'        | `{rel}` | <what this project keeps here> |')
    # The reverse: a row naming something the product no longer seeds protects
    # nothing, while reading as though it does.
    for rel in sorted(set(seeded) - seeded_product):
        errors.append(
            f'{rel}: listed under "## Seeded" but template/manifest.yml does not '
            f'seed it.\n      Either add it to the manifest\'s seeded: list, or move the row '
            f'to\n      "## Adapted" with the reason this instance keeps its own version.')
    return errors


def upgrade(old_ref):
    """Move the pin to the released VERSION and report what the upgrade costs.

    This is the half of the adopter experience no test covers: what does it
    actually take to move from one release to the next, and do the declared
    adaptations still hold once upstream has moved underneath them?
    """
    with open('VERSION') as fh:
        new = fh.read().strip()
    new_ref = f'v{new}'
    if git('rev-parse', '--verify', f'{new_ref}^{{commit}}') is None:
        sys.exit(f'FAIL: {new_ref} not found — cut and tag the release before upgrading to it.')
    if old_ref == new_ref:
        print(f'OK: already pinned to {new_ref} — nothing to upgrade.')
        return 0

    changed = (git('diff', '--name-only', f'{old_ref}..{new_ref}', '--', 'template/core') or '').split()
    changed = [c[len('template/core/'):] for c in changed if c.startswith('template/core/')]
    adapted, _seeded = load_declared()
    conflicts = [c for c in changed if c in adapted]

    print(f'=== self-upgrade {old_ref} -> {new_ref} ===')
    print(f'  {len(changed)} core file(s) changed upstream')

    if conflicts:
        print(f'\n  !! {len(conflicts)} DECLARED ADAPTATION(S) CHANGED UPSTREAM — reconcile by hand:')
        for c in conflicts:
            print(f'     - {c}\n       kept because: {adapted[c]}')
        print('       The instance keeps your version. Re-read the upstream change and decide\n'
              '       whether the adaptation still earns its row in ADAPTATIONS.md.')
    else:
        print('  no declared adaptation was touched upstream — clean upgrade')

    with open('bootstrap/KIT_VERSION') as fh:
        marker = fh.read()
    marker = re.sub(r'^kit_version:.*$', f'kit_version: {new}', marker, count=1, flags=re.M)
    with open('bootstrap/KIT_VERSION', 'w') as fh:
        fh.write(marker)
    print(f'\n  pin moved: bootstrap/KIT_VERSION -> {new}')
    print(f'  now run: python3 scripts/self-conform.py --apply')
    return 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--check', action='store_true', help='verify only; exit 1 on drift')
    ap.add_argument('--apply', action='store_true', help='rewrite the instance from the pin')
    ap.add_argument('--upgrade', action='store_true',
                    help='move the pin to the released VERSION and report the cost')
    args = ap.parse_args()
    if sum([args.check, args.apply, args.upgrade]) != 1:
        sys.exit('FAIL: pass exactly one of --check / --apply / --upgrade')

    # Runs in every mode, before anything is read at the pin or written to disk.
    # `--apply` is the operation that loses data, so it must refuse rather than
    # warn; `--check` fires it in CI so a founding doc cannot reach the default
    # branch unclassified; `--upgrade` fires it too, because the documented
    # sequence is `--upgrade && --apply` and the earlier stop is the kinder one.
    errors = validate_classification()
    if errors:
        print(f'FAIL: {len(errors)} seeded file(s) unclassified — refusing to touch the '
              f'instance.\n')
        for e in errors:
            print(f'  - {e}')
        print('\n  A seeded file holds this project\'s own answers, so re-deriving it '
              'destroys\n  them. ADAPTATIONS.md must say so before the instance is '
              'rewritten (#262).')
        return 1

    version = pinned_version()
    if args.upgrade:
        return upgrade(f'v{version}')

    # A released-but-not-adopted kit has stopped dogfooding. Firing only once the
    # tag exists keeps the release PR itself green (VERSION bumps before the tag
    # is cut), and the signal clears the moment the self-upgrade lands.
    if args.check:
        with open('VERSION') as fh:
            released = fh.read().strip()
        if released != version and git('rev-parse', '--verify', f'v{released}^{{commit}}'):
            print(f'FAIL: v{released} is released but this repo is still pinned to v{version}.\n\n'
                  f'  The kit adopts its own releases — that is the dogfooding (T36.4).\n'
                  f'  Run: python3 scripts/self-conform.py --upgrade '
                  f'&& python3 scripts/self-conform.py --apply')
            return 1
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

    adapted, seeded = load_declared()
    drift, rewritten, skipped = [], [], 0

    for rel in core:
        if rel in adapted:
            skipped += 1
            continue
        if rel in seeded:
            skipped += 1
            if not os.path.exists(rel):
                drift.append(f'{rel}: seeded file missing from the instance — run --apply')
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
                rewritten.append(('created' if have is None else 'overwrote', rel))
        elif have is None:
            drift.append(f'{rel}: missing from the instance — run --apply')
        elif have != want:
            drift.append(f'{rel}: differs from template@{ref}. '
                         f'Fix template/ and re-run --apply, or declare it in ADAPTATIONS.md')

    for rel in seeded:
        if args.apply and not os.path.exists(rel):
            src = git('show', f'{ref}:template/core/{rel}')
            if src is not None:
                os.makedirs(os.path.dirname(rel) or '.', exist_ok=True)
                with open(rel, 'w') as fh:
                    fh.write(transform(src, answers, rel))
                rewritten.append(('seeded', rel))

    if args.apply:
        # Named, not counted. A count is what made #244 invisible: "2 file(s)
        # rewritten" reads identically whether the two were stale generic docs
        # or this project's founding records.
        for what, rel in rewritten:
            print(f'  {what:<9} {rel}')
        print(f'OK: instance conformed to template@{ref} — {len(rewritten)} file(s) rewritten, '
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
