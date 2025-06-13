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

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INSTALLED=()
SKIPPED=()

log_success() {
  printf "✅ %s\n" "$1"
  INSTALLED+=("$1")
}

log_skip() {
  printf "⚠️  %s\n" "$1"
  SKIPPED+=("$1")
}

link_or_merge() {
  local src="$1"
  local dest="$2"
  local label="$3"

  mkdir -p "$(dirname "$dest")"

  if [[ "$DRY_RUN" == true ]]; then
    echo "🧪 DRY RUN: Would install $label to $dest"
    return
  fi

  if [[ -e "$dest" && "$FORCE" == false ]]; then
    if [[ ! -e "$dest.bak" ]]; then
      cp "$dest" "$dest.bak"
      log_success "Backup created: $dest.bak"
    fi
    cp "$src" "$dest"
    log_success "$label installed (merged with backup)"
  else
    ln -sf "$src" "$dest"
    log_success "$label linked"
  fi
}

echo "📅 Started install at $(date)"
echo "🌙 Installing Night Owl CLI Theme Suite..."

# ───── delta ─────
if command -v delta &>/dev/null; then
  mkdir -p "$XDG_CONFIG_HOME/delta/themes"
  link_or_merge "$ROOT_DIR/delta/night-owl-delta.ini" "$XDG_CONFIG_HOME/delta/themes/night-owl.ini" "delta theme"
else
  log_skip "delta not found, skipping"
fi

# ───── bat ─────
if command -v bat &>/dev/null; then
  mkdir -p "$XDG_CONFIG_HOME/bat/themes"
  if [[ "$DRY_RUN" == true ]]; then
    echo "🧪 DRY RUN: Would copy bat theme to $XDG_CONFIG_HOME/bat/themes/"
  else
    cp "$ROOT_DIR/bat/Night-Owl.tmTheme" "$XDG_CONFIG_HOME/bat/themes/"
    bat cache --build
    log_success "bat theme installed and cache rebuilt"
  fi
else
  log_skip "bat not found, skipping"
fi

# ───── k9s ─────
if command -v k9s &>/dev/null; then
  mkdir -p "$XDG_CONFIG_HOME/k9s/skins"
  link_or_merge "$ROOT_DIR/k9s/night-owl.yaml" "$XDG_CONFIG_HOME/k9s/skins/night-owl.yaml" "k9s skin"
else
  log_skip "k9s not found, skipping"
fi

# ───── fzf ─────
if command -v fzf &>/dev/null; then
  mkdir -p "$HOME/.config/zsh/tools"
  link_or_merge "$ROOT_DIR/fzf/fzf-night-owl.zsh" "$HOME/.config/zsh/tools/fzf-night-owl.zsh" "fzf config"
else
  log_skip "fzf not found, skipping"
fi

# ───── starship ─────
if command -v starship &>/dev/null; then
  link_or_merge "$ROOT_DIR/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml" "starship config"
else
  log_skip "starship not found, skipping"
fi

# ───── tmux ─────
if command -v tmux &>/dev/null; then
  link_or_merge "$ROOT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf" "tmux config"
else
  log_skip "tmux not found, skipping"
fi

# ───── iterm2 ─────
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "📦 Please manually import iterm2/Night Owl.itermcolors via iTerm2 Preferences → Profiles → Colors"
else
  log_skip "iTerm2 theme skipped (non-macOS)"
fi

echo "\n📋 Install Summary"
for item in "${INSTALLED[@]}"; do echo "  ✅ $item"; done
for item in "${SKIPPED[@]}"; do echo "  ⚠️ $item (skipped)"; done

if [[ "$DRY_RUN" == true ]]; then
  echo "\n🧪 This was a dry run — no files were actually changed."
fi

echo "🎉 Night Owl CLI Theme setup complete."
