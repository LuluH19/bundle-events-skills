#!/bin/sh
set -eu

root=$(CDPATH='' cd "$(dirname "$0")" && pwd -P)
case "${1:-}" in
  claude) dest="$HOME/.claude/skills" ;;
  codex) dest="${CODEX_HOME:-$HOME/.codex}/skills" ;;
  cursor) dest="$HOME/.cursor/skills" ;;
  *) echo 'Usage: ./install.sh {claude|codex|cursor} [bundle-skill ...]' >&2; exit 2 ;;
esac
shift
if [ "$#" -eq 0 ]; then
  for dir in "$root"/skills/bundle-*; do set -- "$@" "${dir##*/}"; done
fi
for name do
  case "$name" in bundle-*/*|*[!a-z0-9-]*|'') echo "Invalid skill: $name" >&2; exit 2 ;; esac
  [ -f "$root/skills/$name/SKILL.md" ] || { echo "Unknown skill: $name" >&2; exit 2; }
  link="$dest/$name"
  if [ -L "$link" ] && [ "$(readlink "$link")" = "$root/skills/$name" ]; then continue; fi
  if [ -e "$link" ] || [ -L "$link" ]; then echo "Already occupied: $link" >&2; exit 1; fi
done
mkdir -p "$dest"
for name do
  link="$dest/$name"
  if [ ! -L "$link" ]; then ln -s "$root/skills/$name" "$link"; fi
done
echo "Skills available in $dest"
