# Stage 5: Dotfiles & Polish

Final stage: migrate remaining dotfiles (git, tmux, btop, fastfetch), create utility scripts for theme switching, and polish the overall integration.

## What This Stage Accomplishes

1. Configure Git with Omarchy's settings via Home Manager
2. Enhance tmux config with Omarchy's prefix and features
3. Configure btop with theme colors
4. Set up fastfetch with custom display
5. Create theme switching script
6. Create useful utility scripts (screenshots, brightness, etc.)
7. Clean up and remove old KDE references

## Files to Create/Modify

### New Files
- `modules/home-manager/git/default.nix` — Git config (enhance existing)
- `modules/home-manager/btop/default.nix` — btop with theme colors
- `modules/home-manager/fastfetch/default.nix` — Custom fastfetch
- `modules/home-manager/tmux/default.nix` — Enhanced tmux (replace developer module tmux)
- `scripts/theme-switch` — Theme switching script
- `scripts/screenshot` — Screenshot helper
- `scripts/brightness` — Brightness control

### Modified Files
- `modules/home-manager/developer/default.nix` — Remove tmux config (moved to own module), add packages
- `machines/beelink-ser8/home.nix` — Import all new modules
- `machines/surface-book-2/home.nix` — Import all new modules

## Implementation Details

### 1. Git Config (`modules/home-manager/git/default.nix`)

Migrates Omarchy's git settings:

```nix
{ config, lib, pkgs, ... }:

let
  theme = config.theme.colors;
in {
  options.git = {
    enable = lib.mkEnableOption "Git configuration";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      delta.enable = true;
      userName = "Chris Wren";
      userEmail = "chriswrendeveloper@gmail.com";

      signing = {
        key = "C20246199040601C";
        signByDefault = true;
      };

      aliases = {
        cleanup = "!git branch --merged | grep -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        root = "rev-parse --show-toplevel";
      };

      extraConfig = {
        branch.autosetuprebase = "always";
        color.ui = true;
        core.askPass = "";
        credential.helper = "cache";
        github.user = "chriswrendev";
        push.default = "tracking";
        init.defaultBranch = "main";
        pull.rebase = true;
        rerere.enabled = true;
        diff.algorithm = "histogram";
        merge.conflictstyle = "diff3";
      };
    };
  };
}
```

### 2. Tmux Config (`modules/home-manager/tmux/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  theme = config.theme.colors;
in {
  options.tmux-custom = {
    enable = lib.mkEnableOption "Tmux configuration";
  };

  config = lib.mkIf config.tmux-custom.enable {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      historyLimit = 50000;
      keyMode = "vi";
      mouse = true;
      prefix = "C-Space";

      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        resurrect
        continuum
        {
          plugin = tokyo-night-tmux;
          extraConfig = ''
            set -g @tokyo-night-theme "night"
          '';
        }
      ];

      extraConfig = ''
        # Vi mode
        setw -g mode-keys vi
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel wl-copy

        # Split with | and -
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %

        # New window in current path
        bind c new-window -c "#{pane_current_path}"

        # Reload config
        bind r source-file ~/.tmux.conf

        # Status bar
        set -g status-position top
        set -g status-style "bg=#${theme.color0},fg=#${theme.foreground}"
        set -g status-left "#[fg=#${theme.accent},bold] #S "
        set -g status-right "#[fg=#${theme.foreground}] %H:%M "
        set -g window-status-current-format "#[fg=#${theme.background},bg=#${theme.accent},bold] #I:#W "
        set -g window-status-format "#[fg=#${theme.foreground}] #I:#W "

        # Pane borders
        set -g pane-border-style "fg=#${theme.color8}"
        set -g pane-active-border-style "fg=#${theme.accent}"
      '';
    };
  };
}
```

### 3. Btop Config (`modules/home-manager/btop/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  theme = config.theme.colors;
in {
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      update_ms = 1000;
      presets = "cpu:0:default mem:0:default net:0:default";
      vim_keys = true;
      show_gpu = true;
      show_io_stat = true;
      color_theme = "tty";
    };
  };
}
```

### 4. Fastfetch Config (`modules/home-manager/fastfetch/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  theme = config.theme.colors;
in {
  programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        separator = " → ";
      };

      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "host"
        "uptime"
        "packages"
        "shell"
        "terminal"
        "de"
        "wm"
        "wmtheme"
        "separator"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "separator"
        "localip"
        "battery"
        "locale"
        "break"
        "colors"
      ];
    };
  };
}
```

### 5. Theme Switch Script (`scripts/theme-switch`)

```bash
#!/usr/bin/env bash
# Switch the active color theme
# Usage: theme-switch <theme-name>
# Example: theme-switch catppuccin

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIXOS_CONFIG="$(dirname "$SCRIPT_DIR")"

THEMES=(
  tokyo-night catppuccin ethereal everforest flexoki-light
  gruvbox hackerman kanagawa last-horizon lumon matte-black
  miasma nord osaka-jade retro-82 ristretto rose-pine
  solitude vantablack white
)

show_usage() {
  echo "Usage: theme-switch <theme-name>"
  echo ""
  echo "Available themes:"
  for theme in "${THEMES[@]}"; do
    echo "  $theme"
  done
}

if [[ $# -eq 0 ]]; then
  show_usage
  exit 1
fi

THEME="$1"

# Validate theme exists
if [[ ! " ${THEMES[@]} " =~ " ${THEME} " ]]; then
  echo "Error: Unknown theme '$THEME'"
  echo ""
  show_usage
  exit 1
fi

echo "Switching to theme: $THEME"

# Update the theme in the NixOS config
# This modifies the theme.active option in the module
CONFIG_FILE="$NIXOS_CONFIG/modules/home-manager/theme/default.nix"

if [[ -f "$CONFIG_FILE" ]]; then
  # Use sed to update the active theme
  sed -i "s/active = \".*\";/active = \"$THEME\";/" "$CONFIG_FILE"
  echo "Updated $CONFIG_FILE"
else
  echo "Error: Theme config not found at $CONFIG_FILE"
  exit 1
fi

# Rebuild NixOS
echo "Rebuilding NixOS configuration..."
cd "$NIXOS_CONFIG"
sudo nixos-rebuild switch --flake .#

echo ""
echo "Theme switched to: $THEME"
echo "You may need to log out and back in for all changes to take effect."
```

### 6. Screenshot Script (`scripts/screenshot`)

```bash
#!/usr/bin/env bash
# Screenshot helper for Hyprland
# Usage: screenshot [full|area|window]

set -euo pipefail

ACTION="${1:-area}"
OUTPUT_DIR="${XDG_SCREENSHOTS_DIR:-$HOME/Pictures/Screenshots}"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="$OUTPUT_DIR/screenshot_$TIMESTAMP.png"

mkdir -p "$OUTPUT_DIR"

case "$ACTION" in
  full)
    grim "$FILENAME"
    wl-copy < "$FILENAME"
    notify-send "Screenshot saved" "$FILENAME"
    ;;
  area)
    grim -g "$(slurp)" "$FILENAME"
    wl-copy < "$FILENAME"
    notify-send "Screenshot saved" "$FILENAME"
    ;;
  window)
    grim -g "$(hyprctl activewindow -j | jq -r '.at | .[] | join(",")') $(hyprctl activewindow -j | jq -r '.size | .[] | join(",")')" "$FILENAME"
    wl-copy < "$FILENAME"
    notify-send "Screenshot saved" "$FILENAME"
    ;;
  *)
    echo "Usage: screenshot [full|area|window]"
    exit 1
    ;;
esac
```

### 7. Updated developer/default.nix

Remove tmux config (now in its own module), add missing packages:

```nix
# Remove this block (moved to tmux module):
# programs.tmux = { ... };

# Add to packages:
home.packages = with pkgs; [
  # ... existing packages ...
  brightnessctl      # Backlight control
  playerctl          # Media controls
  networkmanagerapplet
  blueman            # Bluetooth manager
  pavucontrol        # Audio control
  nautilus           # File manager
  obsidian           # Note taking
  spotify            # Music
  mpv                # Media player
  imv                # Image viewer
  evince             # PDF viewer
];
```

## Final Machine home.nix

```nix
# machines/beelink-ser8/home.nix
{ ... }:
{ pkgs, ... }:

{
  imports = [
    ../shared/home.nix
    ../../modules/home-manager/theme
    ../../modules/home-manager/dotfiles
    ../../modules/home-manager/developer
    ../../modules/home-manager/zsh
    ../../modules/home-manager/starship
    ../../modules/home-manager/shell
    ../../modules/home-manager/ghostty
    ../../modules/home-manager/hyprland
    ../../modules/home-manager/waybar
    ../../modules/home-manager/mako
    ../../modules/home-manager/hyprlock
    ../../modules/home-manager/hypridle
    ../../modules/home-manager/walker
    ../../modules/home-manager/swayosd
    ../../modules/home-manager/git
    ../../modules/home-manager/tmux-custom
    ../../modules/home-manager/btop
    ../../modules/home-manager/fastfetch
  ];

  dotfiles.enable = true;
  developer.enable = true;
  shell.enable = true;
  hyprland.enable = true;
  waybar.enable = true;
  mako.enable = true;
  hyprlock.enable = true;
  hypridle.enable = true;
  walker.enable = true;
  swayosd.enable = true;
  git.enable = true;
  tmux-custom.enable = true;

  theme.active = "tokyo-night";

  home.stateVersion = "24.11";
}
```

## Verification

1. `nixos-rebuild switch` succeeds on both machines
2. Theme switching script works
3. Git uses rebase on pull, shows diff colors
4. Tmux has Ctrl+Space prefix, vi mode, themed status bar
5. Btop shows with theme background
6. Fastfetch shows correct system info
7. All keybindings work end-to-end
8. No KDE/SDDM remnants
9. Screen lock, notifications, app launcher all functional
10. Volume/brightness controls work
