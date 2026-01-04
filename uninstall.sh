#!/usr/bin/env bash

set -euo pipefail

DRY_RUN=false
FORCE=false

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    *)
      echo "❌ Unknown option: $1"
      exit 1
      ;;
  esac
done

log() {
  printf "%s\n" "$1"
}

del() {
  local target="$1"
  if [[ -e "$target" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
      log "🧪 DRY RUN: Would remove $target"
    else
      rm -rf "$target"
      log "🗑️ Removed $target"
    fi
  fi
}

restore_bak() {
  local path="$1"
  if [[ -e "$path.bak" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
      log "🧪 DRY RUN: Would restore $path.bak → $path"
    else
      mv "$path.bak" "$path"
      log "♻️ Restored backup: $path"
    fi
  fi
}

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log "🌘 Uninstalling Night Owl CLI Theme..."

# delta
if command -v delta &>/dev/null; then
  del "$XDG_CONFIG_HOME/delta/themes/night-owl.ini"
  restore_bak "$XDG_CONFIG_HOME/delta/themes/night-owl.ini"
else
  log "⚠️ delta not installed, skipping"
fi

# git
if command -v git &>/dev/null; then
  del "$XDG_CONFIG_HOME/git/night-owl-colors.gitconfig"
  restore_bak "$XDG_CONFIG_HOME/git/night-owl-colors.gitconfig"
else
  log "⚠️ git not installed, skipping"
fi

# bat
if command -v bat &>/dev/null; then
  del "$XDG_CONFIG_HOME/bat/themes/Night-Owl.tmTheme"
else
  log "⚠️ bat not installed, skipping"
fi

# eza
if command -v eza &>/dev/null; then
  del "$XDG_CONFIG_HOME/eza/theme.yml"
  restore_bak "$XDG_CONFIG_HOME/eza/theme.yml"
else
  log "⚠️ eza not installed, skipping"
fi

# k9s
if command -v k9s &>/dev/null; then
  del "$XDG_CONFIG_HOME/k9s/skins/night-owl.yaml"
  restore_bak "$XDG_CONFIG_HOME/k9s/skins/night-owl.yaml"
else
  log "⚠️ k9s not installed, skipping"
fi

# fzf
if command -v fzf &>/dev/null; then
  del "$HOME/.config/zsh/tools/fzf-night-owl.zsh"
  restore_bak "$HOME/.config/zsh/tools/fzf-night-owl.zsh"
else
  log "⚠️ fzf not installed, skipping"
fi

# starship
if command -v starship &>/dev/null; then
  del "$XDG_CONFIG_HOME/starship.toml"
  restore_bak "$XDG_CONFIG_HOME/starship.toml"
else
  log "⚠️ starship not installed, skipping"
fi

# tmux
if command -v tmux &>/dev/null; then
  del "$HOME/.tmux.conf"
  restore_bak "$HOME/.tmux.conf"
else
  log "⚠️ tmux not installed, skipping"
fi

# iterm2 - manual
if [[ "$OSTYPE" == "darwin"* ]]; then
  log "🖐 Please manually remove iTerm2 color preset: 'Night Owl' via Preferences → Profiles"
fi

log "🧹 Uninstallation complete."
if [[ "$DRY_RUN" == true ]]; then
  log "(This was a dry run — no files were actually removed.)"
fi
