#!/usr/bin/env bash

set -euo pipefail

echo "🌙 Installing Night Owl CLI Theme..."

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# symlink helper
link_theme() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  echo "✅ Linked: $dest"
}

# delta
if command -v delta &>/dev/null; then
  link_theme "$ROOT_DIR/delta/night-owl-delta.ini" "$XDG_CONFIG_HOME/delta/themes.gitconfig"
else
  echo "⚠️ delta not found, skipping..."
fi

# bat
if command -v bat &>/dev/null; then
  mkdir -p "$XDG_CONFIG_HOME/bat/themes"
  cp "$ROOT_DIR/bat/Night-Owl.tmTheme" "$XDG_CONFIG_HOME/bat/themes/"
  bat cache --build
  echo "✅ bat theme installed and cache rebuilt."
else
  echo "⚠️ bat not found, skipping..."
fi

# k9s
if command -v k9s &>/dev/null; then
  link_theme "$ROOT_DIR/k9s/night-owl.yaml" "$XDG_CONFIG_HOME/k9s/skins/night-owl.yaml"
else
  echo "⚠️ k9s not found, skipping..."
fi

echo "🎉 Night Owl theme installed!"
