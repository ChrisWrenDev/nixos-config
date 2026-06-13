# Stage 2: Terminal & Shell

Configure Ghostty as the default terminal with Omarchy's config structure, migrate shell aliases/functions, and apply theme colors to the terminal.

## What This Stage Accomplishes

1. Install and configure Ghostty via Home Manager
2. Apply Omarchy's terminal config structure (font, padding, cursor)
3. Integrate theme colors into Ghostty
4. Migrate Omarchy's bash aliases and functions to NixOS
5. Keep existing Zsh + Starship setup, enhance with theme colors

## Files to Create/Modify

### New Files
- `modules/home-manager/ghostty/default.nix` — Ghostty Home Manager module
- `modules/home-manager/shell/default.nix` — Shell aliases, functions, env vars

### Modified Files
- `machines/beelink-ser8/home.nix` — Import ghostty + shell modules
- `machines/surface-book-2/home.nix` — Import ghostty + shell modules
- `modules/home-manager/developer/default.nix` — Add missing packages (eza, etc.)
- `shared/home.nix` — Ensure eza, bat, etc. are available

## Implementation Details

### 1. Ghostty Module (`modules/home-manager/ghostty/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.ghostty;
  theme = config.theme.colors;
in {
  options.programs.ghostty = {
    enable = lib.mkEnableOption "Ghostty terminal";
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        # Font
        font-family = "JetBrainsMono Nerd Font";
        font-size = 9;

        # Window
        window-padding-x = 14;
        window-padding-y = 14;
        window-decoration = false;
        window-theme = "dark";

        # Cursor
        cursor-style = "block";
        cursor-style-blink = false;

        # Theme colors (injected from theme module)
        background = "#${theme.background}";
        foreground = "#${theme.foreground}";
        cursor-color = "#${theme.cursor}";
        selection-foreground = "#${theme.selection_foreground}";
        selection-background = "#${theme.selection_background}";

        palette = [
          "0=#${theme.color0}"
          "1=#${theme.color1}"
          "2=#${theme.color2}"
          "3=#${theme.color3}"
          "4=#${theme.color4}"
          "5=#${theme.color5}"
          "6=#${theme.color6}"
          "7=#${theme.color7}"
          "8=#${theme.color8}"
          "9=#${theme.color9}"
          "10=#${theme.color10}"
          "11=#${theme.color11}"
          "12=#${theme.color12}"
          "13=#${theme.color13}"
          "14=#${theme.color14}"
          "15=#${theme.color15}"
        ];

        # Keybindings
        keybind = [
          "ctrl+space=new_split:down"
          "ctrl+shift+o=new_split:right"
          "ctrl+shift+w=close_surface"
          "ctrl+shift+h=goto_split:left"
          "ctrl+shift+l=goto_split:right"
          "ctrl+shift+k=goto_split:top"
          "ctrl+shift+j=goto_split:bottom"
        ];
      };
    };
  };
}
```

### 2. Shell Module (`modules/home-manager/shell/default.nix`)

Migrates Omarchy's bash aliases and functions into NixOS-native Home Manager config.

```nix
{ config, lib, pkgs, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in {
  options.shell = {
    enable = lib.mkEnableOption "Shell aliases and functions";
  };

  config = lib.mkIf config.shell.enable {
    home.shellAliases = {
      # File listing
      ls = "eza -lh --group-directories-first --icons=auto";
      lt = "eza --tree --level=2 --long --icons --git";
      ll = "eza -la --group-directories-first --icons=auto";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Editors
      n = "nvim .";

      # Git
      g = "git";
      gcm = "git commit -m";
      gs = "git status";
      gd = "git diff";
      gl = "git log --oneline -20";
      gp = "git push";

      # Docker
      d = "docker";
      dc = "docker compose";
      dps = "docker ps";

      # Rails
      r = "rails";
      rc = "rails console";
      rs = "rails server";

      # Tools
      t = "tmux attach || tmux new -s Work";
      c = "opencode";
      open = "xdg-open";
    };

    programs.zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.eza = lib.mkIf isLinux {
      enable = true;
      enableZshIntegration = true;
    };

    programs.bat = {
      enable = true;
      config.theme = "ansi";
    };

    home.sessionVariables = {
      SUDO_EDITOR = "EDITOR";
      BAT_THEME = "ansi";
      MANROFFOPT = "-c";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      # Settings come from the starship module
    };
  };
}
```

### 3. Update shared/home.nix

Ensure these packages are available system-wide:
```nix
home.packages = with pkgs; [
  eza
  bat
  fd
  fzf
  jq
  ripgrep
  tree
  wget
  curl
];
```

## Verification

1. Ghostty launches with correct theme colors
2. `ls` uses eza, `cd` uses zoxide
3. All aliases work
4. Font is JetBrainsMono Nerd Font at size 9
5. Window padding is 14px
