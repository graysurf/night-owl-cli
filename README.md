# 🌙 Night Owl CLI Theme Suite

A fully synchronized CLI color theme based on the famous **Night Owl** palette, redesigned for **low-light, high-focus terminal environments**.

This project brings Night Owl's signature cool tones and soft contrasts to your favorite command-line tools, including:

- 🐙 `delta` – Git diff viewer
- 🐱 `bat` – Syntax-highlighting cat replacement
- 📡 `k9s` – Kubernetes TUI client
- 🧬 `fzf` – Fuzzy finder with preview integration
- 🔮 `iterm2` – Terminal emulator color scheme
- 🧪 `tmux` – Status line and pane border theming
- 🚀 `starship` – Minimal prompt with semantic color cues

## 🎯 Philosophy
> Night Owl is more than a theme — it’s a workspace ritual.

- Optimized for **focus** and **clarity** in low-light environments
- Reduces eye strain without sacrificing syntax readability
- Carefully selected saturation and brightness levels per tool

## 📁 Directory Structure

```
night-owl-cli/
├── delta/
│   └── night-owl-delta.ini
├── bat/
│   └── Night-Owl.tmTheme
├── k9s/
│   └── night-owl.yaml
├── fzf/
│   └── fzf-night-owl.zsh
├── iterm2/
│   └── Night-Owl.itermcolors
├── tmux/
│   └── .tmux.conf
├── starship/
│   └── starship.toml
├── install.sh
|
└── README.md
```

## 🔧 Setup Instructions

### 🐙 delta
1. Copy `delta/night-owl-delta.ini` to `~/.config/delta/themes/night-owl.ini`
2. Add the following to `~/.gitconfig`:

   ```ini
   [delta]
   features = night-owl
   ```

### 🐱 bat
1. Copy `bat/Night-Owl-Lowlight.tmTheme` to `~/.config/bat/themes/`
2. Run: `bat cache --build`
3. Set theme: `export BAT_THEME="Night-Owl-Lowlight"`

### 📡 k9s
1. Copy `k9s/night-owl.yaml` to `~/.k9s/skins/night-owl.yaml`
2. In `~/.k9s/config.yaml`, set:

   ```yaml
   k9s:
     skin: night-owl
   ```

### 🧬 fzf
1. Source the file in your `.zshrc`:

   ```sh
   source "$ZDOTDIR/tools/fzf-night-owl.zsh"
   ```

### 🗂️ lsd
1. Replace or merge `lsd/config.yaml` into `~/.config/lsd/config.yaml`

### 🔮 iterm2
1. Go to `Preferences → Profiles → Colors → Color Presets... → Import...`
2. Select `iterm2/Night Owl.itermcolors`
3. Apply the theme in Color Presets dropdown

### 🧪 tmux
1. Source `tmux/.tmux.conf` or merge into your own `.tmux.conf`
2. Reload tmux config: `tmux source-file ~/.tmux.conf`

### 🚀 starship
1. Replace `~/.config/starship.toml` with `starship/starship.toml` or merge them

## ✅ Licensing

MIT License. Theme color values adapted from [Night Owl VSCode theme](https://vscodethemes.com/e/sdras.night-owl/night-owl) by Sarah Drasner.

This project is a CLI-oriented adaptation for personal and community use.

---

_Contributions welcome. Pull requests for additional tool integrations or refinements appreciated._
