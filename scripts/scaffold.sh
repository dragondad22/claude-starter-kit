#!/usr/bin/env bash
# scaffold.sh — the kit's install engine: scaffold a project from template/ (T3.7).
#
# Additive model: installs the core (always), stages EVERY module's payload
# under <target>/bootstrap/modules/<name>/ so later trigger-driven installs
# work offline and version-consistent (T3.10), writes the bootstrap/KIT_VERSION
# upgrade marker (T18), and applies any modules requested now (per interview
# answers) via the shipped in-project engine.
#
# Kit-dev tool: run from a kit checkout; does not ship. The in-project half
# (template/core/ai/scripts/scaffold-module.sh) is what ships.
#
# Usage (from the kit repo root):
#   bash scripts/scaffold.sh <target-dir> [module ...]
# e.g.
#   bash scripts/scaffold.sh ~/src/my-app db ui
#
# Existing files in the target are never overwritten (skip + warn) — safe to
# run into a non-empty repo. Portable on purpose (bash 3.2, no PyYAML).

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MF="$ROOT_DIR/template/manifest.yml"

die() { echo "ABORT: $*" >&2; exit 1; }

[ -f "$MF" ] || die "no template/manifest.yml — run from a kit checkout root"
[ $# -ge 1 ] || die "usage: bash scripts/scaffold.sh <target-dir> [module ...]"

TARGET="$1"; shift
mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"
[ "$TARGET" != "$ROOT_DIR" ] || die "target is the kit checkout itself"

# --- manifest parsing (same constrained subset scaffold-module.sh reads) ----

core_files() {
  awk '
    /^core:/ { incore=1; next }
    /^[^ ]/ { incore=0 }
    incore && $1=="files:" { infiles=1; next }
    incore && infiles { if ($1=="-") print $2; else infiles=0 }
  ' "$MF"
}

module_names() {
  awk '
    /^modules:/ { inmods=1; next }
    /^[^ ]/    { inmods=0 }
    inmods && /^  [A-Za-z0-9_-]+:[[:space:]]*$/ { name=$1; sub(/:$/, "", name); print name }
  ' "$MF"
}

module_files() { # $1 = module name
  awk -v mod="$1" '
    /^modules:/ { inmods=1; next }
    /^[^ ]/    { inmods=0 }
    inmods && /^  [A-Za-z0-9_-]+:/ { cur=$1; sub(/:$/, "", cur); infiles=0; next }
    inmods && cur==mod && $1=="files:" { if ($0 !~ /\[\]/) infiles=1; next }
    inmods && cur==mod && infiles { if ($1=="-") print $2; else infiles=0 }
  ' "$MF"
}

copy_into() { # $1 = source file, $2 = destination file; skip existing
  if [ -e "$2" ]; then
    echo "  skip (already exists): ${2#"$TARGET"/}"
  else
    mkdir -p "$(dirname "$2")"
    cp "$1" "$2"
    copied=$((copied + 1))
    # A pre-existing .gitignore can swallow a file we just wrote (issue #121):
    # it lands on disk but silently falls out of the adoption commit.
    if [ "$TARGET_IS_GIT" = "true" ] && git -C "$TARGET" check-ignore -q "${2#"$TARGET"/}"; then
      ignored_files="$ignored_files
  ${2#"$TARGET"/}"
    fi
  fi
}

TARGET_IS_GIT="$(git -C "$TARGET" rev-parse --is-inside-work-tree 2>/dev/null || echo false)"
ignored_files=""

echo "=== kit scaffold -> $TARGET ==="

# 1. Core: every manifest-listed core file, paths mirroring the project root.
copied=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ -f "$ROOT_DIR/template/core/$f" ] || die "manifest lists missing core file: $f"
  copy_into "$ROOT_DIR/template/core/$f" "$TARGET/$f"
done < <(core_files)
echo "  core: $copied file(s) installed"

# 2. Stage every module payload + the manifest (T3.10: offline, version-consistent).
copied=0
while IFS= read -r m; do
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    [ -f "$ROOT_DIR/template/modules/$m/$f" ] || die "manifest lists missing module file: $m/$f"
    copy_into "$ROOT_DIR/template/modules/$m/$f" "$TARGET/bootstrap/modules/$m/$f"
  done < <(module_files "$m")
done < <(module_names)
copy_into "$MF" "$TARGET/bootstrap/modules/manifest.yml"
echo "  modules: $copied file(s) staged under bootstrap/modules/"

# 3. Upgrade marker (T18): kit version + scaffold date + installed-module list.
if [ -e "$TARGET/bootstrap/KIT_VERSION" ]; then
  echo "  skip (already exists): bootstrap/KIT_VERSION"
else
  KITVER="$(tr -d '[:space:]' < "$ROOT_DIR/VERSION")"
  cat > "$TARGET/bootstrap/KIT_VERSION" <<EOF
# Kit upgrade marker — written by the kit scaffold engine at inception.
# Records the kit version this project was scaffolded from and every module
# installed since; the kit-delta upgrade check reads it. Do not delete.
kit_version: $KITVER
scaffolded: $(date +%Y-%m-%d)
modules:
EOF
  echo "  marker: bootstrap/KIT_VERSION written (kit $KITVER)"
fi

# 4. Apply modules requested now, via the shipped in-project engine.
for m in "$@"; do
  ( cd "$TARGET" && bash ai/scripts/scaffold-module.sh "$m" )
done

if [ -n "$ignored_files" ]; then
  echo ""
  echo "WARN: installed but excluded by the target repo's .gitignore — on disk, yet"
  echo "      they will NOT be committed until the ignore rule is adjusted (whitelist"
  echo "      shape: 'dir/*' + '!dir/README.md' instead of a directory-level 'dir/'):$ignored_files"
fi

echo ""
echo "OK: scaffolded. Next: open the project in Claude Code and run /bootstrap"
echo "    (or follow bootstrap/SETUP.md by hand). Later, when a module trigger"
echo "    fires: bash ai/scripts/scaffold-module.sh <module>"
