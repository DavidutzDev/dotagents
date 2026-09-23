#!/usr/bin/env bash
# dotagents. Link this repo into every agent harness on this machine.
# Idempotent: safe to re-run after every `git pull`.
#
#   ./install.sh            apply
#   ./install.sh --dry-run  show what would change, touch nothing
set -euo pipefail

REPO="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
DRY=0
case "${1:-}" in --dry-run|-n) DRY=1 ;; esac

BACKUP="$HOME/.agents-backup/$(date +%Y%m%d-%H%M%S)"
backed_up=0

say()  { printf '%s\n' "$*"; }
tilde(){ printf '%s' "${1/#$HOME/\~}"; }
run()  { if (( DRY )); then printf '        [dry] %s\n' "$*"; else "$@"; fi; }

# link <target> <linkpath>
link() {
  local target="$1" linkpath="$2" rel cur
  rel="${linkpath#"$HOME"/}"

  if [[ -L "$linkpath" ]]; then
    cur="$(readlink -f -- "$linkpath" 2>/dev/null || true)"
    if [[ -n "$cur" && "$cur" == "$(readlink -f -- "$target")" ]]; then
      printf '  ok      %s\n' "$(tilde "$linkpath")"
      return 0
    fi
    printf '  relink  %s\n' "$(tilde "$linkpath")"
    run rm -f -- "$linkpath"
  elif [[ -e "$linkpath" ]]; then
    # Never back up in place: a *.bak dir inside skills/ would load as a duplicate skill.
    printf '  backup  %s -> %s\n' "$(tilde "$linkpath")" "$(tilde "$BACKUP")/$rel"
    run mkdir -p -- "$BACKUP/$(dirname -- "$rel")"
    run mv -- "$linkpath" "$BACKUP/$rel"
    backed_up=1
  else
    printf '  link    %s\n' "$(tilde "$linkpath")"
  fi

  run mkdir -p -- "$(dirname -- "$linkpath")"
  run ln -s -- "$target" "$linkpath"
}

# link_tree <repo subdir> <dest dir>. Links every child directory
link_tree() {
  local src="$REPO/$1" dest="$2" d name found=0
  [[ -d "$src" ]] || return 0
  shopt -s nullglob
  for d in "$src"/*/; do
    name="$(basename -- "$d")"
    link "$src/$name" "$dest/$name"
    found=1
  done
  shopt -u nullglob
  (( found )) || say "  (none)"
}

say "dotagents  $(tilde "$REPO")"
(( DRY )) && say "           dry run, nothing will be written"
say

say "skills -> Claude Code"
link_tree skills "$HOME/.claude/skills"

say
say "skills -> opencode"
if [[ "$REPO" == "$HOME/.agents" ]]; then
  say "  native  ~/.agents/skills is read directly, nothing to link"
elif [[ -d "$HOME/.config/opencode" ]]; then
  link_tree skills "$HOME/.config/opencode/skill"
else
  say "  skip    opencode not installed"
fi

say
say "instructions"
[[ -f "$REPO/claude/CLAUDE.md" ]] && link "$REPO/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
[[ -f "$REPO/claude/RTK.md"    ]] && link "$REPO/claude/RTK.md"    "$HOME/.claude/RTK.md"
if [[ -f "$REPO/AGENTS.md" && -d "$HOME/.config/opencode" ]]; then
  link "$REPO/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"
fi

say
say "harnesses detected"
for h in claude opencode t3code gemini codex crush cursor-agent; do
  if command -v "$h" >/dev/null 2>&1; then
    printf '  %-12s %s\n' "$h" "$(command -v "$h")"
  fi
done

if (( backed_up )); then
  say
  say "replaced files were moved to $(tilde "$BACKUP")"
fi
say
say "done. re-run after every 'git pull'."
