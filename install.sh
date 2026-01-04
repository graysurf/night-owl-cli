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
    -h|--help)
      cat <<'EOF'
Usage: ./install.sh [--dry-run] [--force]

Options:
  --dry-run   Print actions without changing files
  --force     Overwrite without creating .bak backups
EOF
      exit 0
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

echo "🌙 Installing Night Owl CLI Theme Suite..."
echo "📅 Started install at $(date)"

log_success() {
  printf "✅ %s\n" "$1"
  INSTALLED+=("$1")
}

log_skip() {
  printf "⚠️  %s\n" "$1"
  SKIPPED+=("$1")
}

install_file() {
  local src="$1"
  local dest="$2"
  local label="$3"
  local mode="${4:-link}"

  if [[ "$DRY_RUN" == true ]]; then
    echo "🧪 DRY RUN: Would install $label to $dest"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -e "$dest" && "$FORCE" == false ]]; then
    if [[ ! -e "$dest.bak" ]]; then
      cp "$dest" "$dest.bak"
      log_success "Backup created: $dest.bak"
    fi
    cp "$src" "$dest"
    log_success "$label installed"
  else
    case "$mode" in
      copy)
        cp "$src" "$dest"
        log_success "$label installed"
        ;;
      link)
        ln -sf "$src" "$dest"
        log_success "$label linked"
        ;;
      *)
        echo "❌ Unknown install mode: $mode"
        return 1
        ;;
    esac
  fi
}

# ───── delta ─────
if command -v delta &>/dev/null; then
  install_file "$ROOT_DIR/delta/night-owl-delta.ini" "$XDG_CONFIG_HOME/delta/themes/night-owl.ini" "delta theme"
else
  log_skip "delta not found, skipping"
fi

# ───── git ─────
if command -v git &>/dev/null; then
  install_file "$ROOT_DIR/git/night-owl-colors.gitconfig" "$XDG_CONFIG_HOME/git/night-owl-colors.gitconfig" "git colors"
else
  log_skip "git not found, skipping"
fi

# ───── bat ─────
if command -v bat &>/dev/null; then
  if [[ "$DRY_RUN" == true ]]; then
    echo "🧪 DRY RUN: Would copy bat theme to $XDG_CONFIG_HOME/bat/themes/"
  else
    mkdir -p "$XDG_CONFIG_HOME/bat/themes"
    cp "$ROOT_DIR/bat/Night-Owl.tmTheme" "$XDG_CONFIG_HOME/bat/themes/"
    bat cache --build
    log_success "bat theme installed and cache rebuilt"
  fi
else
  log_skip "bat not found, skipping"
fi

# ───── eza ─────
if command -v eza &>/dev/null; then
  install_file "$ROOT_DIR/eza/night-owl.yml" "$XDG_CONFIG_HOME/eza/theme.yml" "eza theme" copy
else
  log_skip "eza not found, skipping"
fi

# ───── k9s ─────
if command -v k9s &>/dev/null; then
  install_file "$ROOT_DIR/k9s/night-owl.yaml" "$XDG_CONFIG_HOME/k9s/skins/night-owl.yaml" "k9s skin"
else
  log_skip "k9s not found, skipping"
fi

# ───── fzf ─────
if command -v fzf &>/dev/null; then
  install_file "$ROOT_DIR/fzf/fzf-night-owl.zsh" "$HOME/.config/zsh/tools/fzf-night-owl.zsh" "fzf config"
else
  log_skip "fzf not found, skipping"
fi

# ───── starship ─────
if command -v starship &>/dev/null; then
  install_file "$ROOT_DIR/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml" "starship config"
else
  log_skip "starship not found, skipping"
fi

# ───── tmux ─────
if command -v tmux &>/dev/null; then
  install_file "$ROOT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf" "tmux config"
else
  log_skip "tmux not found, skipping"
fi

# ───── iterm2 ─────
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "📦 Please manually import iterm2/Night Owl.itermcolors via iTerm2 Preferences → Profiles → Colors"
else
  log_skip "iTerm2 theme skipped (non-macOS)"
fi

printf "\n📋 Install Summary\n"
for item in "${INSTALLED[@]}"; do echo "  ✅ $item"; done
for item in "${SKIPPED[@]}"; do echo "  ⚠️ $item (skipped)"; done

if [[ "$DRY_RUN" == true ]]; then
  printf "\n🧪 This was a dry run — no files were actually changed.\n"
fi

echo "🎉 Night Owl CLI Theme setup complete."
