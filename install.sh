#!/bin/sh
set -eu

root=$(CDPATH='' cd "$(dirname "$0")" && pwd -P)
old=
case "${1:-}" in
  claude) dest="$HOME/.claude/skills" ;;
  codex) dest="$HOME/.agents/skills"; old="${CODEX_HOME:-$HOME/.codex}/skills" ;;
  cursor) dest="$HOME/.cursor/skills" ;;
  *) echo 'Usage: ./install.sh {claude|codex|cursor} [bundle-skill ...]' >&2; exit 2 ;;
esac
shift
if [ "$#" -eq 0 ]; then
  for dir in "$root"/skills/bundle-*; do set -- "$@" "${dir##*/}"; done
fi

# Git Bash copies instead of linking, so Windows uses a directory junction.
make_link() {
  case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
      cmd //c mklink //J "$(cygpath -w "$2")" "$(cygpath -w "$1")" >/dev/null ;;
    *) ln -s "$1" "$2" ;;
  esac
}

# A full copy left by an earlier install, identical to this clone.
is_copy() {
  [ -d "$2" ] && [ ! -L "$2" ] && diff -r "$1" "$2" >/dev/null 2>&1
}

occupied=
for name do
  case "$name" in bundle-*/*|*[!a-z0-9-]*|'') echo "Invalid skill: $name" >&2; exit 2 ;; esac
  skill="$root/skills/$name"
  link="$dest/$name"
  [ -f "$skill/SKILL.md" ] || { echo "Unknown skill: $name" >&2; exit 2; }
  if [ "$link" -ef "$skill" ] || is_copy "$skill" "$link"; then continue; fi
  if [ -e "$link" ] || [ -L "$link" ]; then
    echo "Already occupied: $link" >&2
    occupied=yes
  fi
done
if [ -n "$occupied" ]; then
  echo 'Nothing was installed. Move or delete the paths above, then run this again.' >&2
  exit 1
fi

mkdir -p "$dest"
for name do
  skill="$root/skills/$name"
  link="$dest/$name"
  if ! [ "$link" -ef "$skill" ]; then
    if is_copy "$skill" "$link"; then rm -r "$link"; fi
    make_link "$skill" "$link"
    [ "$link" -ef "$skill" ] || { echo "Could not link: $link" >&2; exit 1; }
  fi
  if [ -n "$old" ] && [ -L "$old/$name" ] && [ "$old/$name" -ef "$skill" ]; then
    rm "$old/$name"
  fi
done
echo "Skills available in $dest"
