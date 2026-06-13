# Stage 6: Dotfiles to Nix Migration

Migrate the remaining 6 dotfiles (nvim, tmux, zsh, wezterm, vscode, opencode) from the external `dotfiles` flake input into Nix-managed modules, then remove the `dotfiles` module entirely.

## What This Stage Accomplishes

1. Create a Neovim module that deploys the Lua config via `xdg.configFile`
2. Expand the Zsh module from a minimal stub to full config (aliases, options, history, plugins, env vars)
3. Create a WezTerm module with theme colors, font, and window config
4. Expand the VS Code module to include settings.json and keybindings.json
5. Create an OpenCode module for `opencode.json`
6. Remove the `dotfiles` module and its flake input
7. Update all machine `home.nix` files

## Current State

| Tool | Current State | Target State |
|------|--------------|-------------|
| **nvim** | Symlinked from `dotfilesRepo/nvim` via `dotfiles` module | `xdg.configFile` in new `nvim` module, files copied into nixos-config repo |
| **tmux** | Double-configured: `dotfiles` symlinks `.tmux.conf` + `tmux-custom` HM module | Remove from `dotfiles`; `tmux-custom` already handles it |
| **zsh** | `.zshrc` symlinked from dotfiles; Nix module is minimal (3 lines) | Inline full zsh config into expanded `zsh` module |
| **wezterm** | `.wezterm.lua` symlinked from dotfiles; `programs.wezterm` enabled in `developer` but unconfigured | Add theme/font/window config to new `wezterm` module |
| **vscode** | `settings.json` symlinked from dotfiles; Nix module only has extensions | Merge settings + keybindings + extensions into `vs-code` module |
| **opencode** | Not in Nix at all | New `opencode` module managing `opencode.json` via `xdg.configFile` |

## Files to Create

### New Files
- `modules/home-manager/nvim/default.nix` — Neovim module (xdg.configFile to deploy Lua config)
- `modules/home-manager/wezterm/default.nix` — WezTerm module with theme integration
- `modules/home-manager/opencode/default.nix` — OpenCode module for opencode.json
- `nvim/` (directory) — Copy entire nvim config from `../dotfiles/nvim/` into repo

### Modified Files
- `modules/home-manager/zsh/default.nix` — Expand from 7-line stub to full config
- `modules/home-manager/vs-code/default.nix` — Add settings + keybindings + merge extensions
- `machines/beelink-ser8/home.nix` — Remove dotfiles, add new modules
- `machines/surface-book-2/home.nix` — Remove dotfiles, add new modules
- `machines/vm-intel/home.nix` — Remove dotfiles, add nvim + opencode
- `machines/vm-aarch64/home.nix` — Remove dotfiles, add nvim + opencode
- `machines/vm-aarch64-prl/home.nix` — Remove dotfiles, add nvim + opencode
- `machines/vm-aarch64-utm/home.nix` — Remove dotfiles, add nvim + opencode
- `machines/macbook/home.nix` — Remove dotfiles, add new modules (with darwin conditionals)
- `flake.nix` — Remove `dotfiles` input

### Deleted Files
- `modules/home-manager/dotfiles/default.nix` — Replaced by individual modules

## Implementation Details

### 1. Neovim Module (`modules/home-manager/nvim/default.nix`)

Copy the entire `nvim/` directory from `../dotfiles/nvim/` into the repo root, then deploy via `xdg.configFile`:

```nix
{ ... }:
{
  xdg.configFile."nvim".source = ./nvim;
}
```

This preserves all Lua files as-is and deploys them via Nix symlink to `~/.config/nvim`.

### 2. WezTerm Module (`modules/home-manager/wezterm/default.nix`)

`programs.wezterm` is already enabled in `developer/default.nix`. This module adds the config using theme colors:

```nix
{ config, lib, ... }:
let
  theme = config.theme.colorsHex;
in {
  programs.wezterm = {
    extraConfig = ''
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()

      config.color_scheme = "TokyoNight"
      config.font = wezterm.font("MesloLGS Nerd Font Mono")
      config.font_size = 18
      config.hide_tab_bar_if_only_one_tab = true
      config.scrollback_lines = 3500
      config.enable_scroll_bar = true
      config.window_decorations = "RESIZE"

      return config
    '';
  };
}
```

Move the `programs.wezterm` enable from `developer/default.nix` to this new module.

### 3. Zsh Module (`modules/home-manager/zsh/default.nix`)

Expand from the current minimal stub to full config. Inline all content from the dotfiles `.zshrc`:

```nix
{ config, lib, pkgs, ... }:
let
  theme = config.theme.colorsHex;
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  options.zsh-custom = {
    enable = lib.mkEnableOption "Full zsh configuration";
  };

  config = lib.mkIf config.zsh-custom.enable {
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      # ZSH Options
      initExtra = ''
        setopt AUTOCD
        setopt PROMPT_SUBST
        setopt MENU_COMPLETE
        setopt LIST_PACKED
        setopt AUTO_LIST
        setopt HIST_IGNORE_DUPS
        setopt HIST_FIND_NO_DUPS
        setopt COMPLETE_IN_WORD
        stty start undef
        stty stop undef
        setopt noflowcontrol

        # History
        HISTFILE=$HOME/.zhistory
        SAVEHIST=1000
        HISTSIZE=999
        setopt share_history
        setopt hist_expire_dups_first
        setopt hist_ignore_dups
        setopt hist_verify

        # Arrow key history search
        bindkey '^[[A' history-search-backward
        bindkey '^[[B' history-search-forward

        # Integrations
        eval "$(fzf --zsh)"
        eval "$(starship init zsh)"
        eval "$(mise activate zsh)"
      '';

      # Shell aliases
      shellAliases = {
        x = "exit";
        c = "clear";
        k = "kubectl";
        tf = "terraform";
      };

      # Platform-conditional plugin sourcing
      initExtraFirst = lib.mkBefore (
        if isDarwin then ''
          source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        '' else ''
          source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ''
      );
    };

    # Environment variables
    home.sessionVariables = {
      FZF_DEFAULT_OPTS = "--color=fg:${theme.foreground},bg:${theme.background},hl:${theme.accent},fg+:${theme.foreground},bg+:${theme.color0},hl+:${theme.accent},info:${theme.color4},prompt:${theme.color6},pointer:${theme.color6},marker:${theme.color6},spinner:${theme.color6},header:${theme.color6}";
      FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
      BAT_THEME = "tokyonight_night";
      RUSTC_WRAPPER = "sccache";
      RUSTUP_HOME = "$HOME/rust-cache/rustup";
      CARGO_HOME = "$HOME/rust-cache/cargo";
      CARGO_TARGET_DIR = "$HOME/rust-cache/target";
      SCCACHE_DIR = "$HOME/rust-cache/sccache";
      SCCACHE_CACHE_SIZE = "50G";
    };
  };
}
```

### 4. VS Code Module (`modules/home-manager/vs-code/default.nix`)

Expand to include settings.json (with platform-conditional paths), keybindings.json, and merge extensions:

```nix
{ config, lib, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    # Inline settings.json content
    userSettings = {
      # Visuals
      "window.zoomLevel" = 0.25;
      "workbench.colorTheme" = "GitHub Dark Default";
      "editor.fontFamily" = "Input Mono, monospace";
      "terminal.integrated.fontFamily" = "MesloLGS NF";
      "editor.fontSize" = 18;
      # ... (all other settings from settings.json)

      # Platform-conditional zig paths
      "zig.path" = if isDarwin
        then "/Users/chriswren/Library/Application Support/Code/User/globalStorage/ziglang.vscode-zig/zig_install/zig"
        else "~/.config/Code/User/globalStorage/ziglang.vscode-zig/zig_install/zig";
      "zig.zls.path" = if isDarwin
        then "/Users/chriswren/Library/Application Support/Code/User/globalStorage/ziglang.vscode-zig/zls_install/zls"
        else "~/.config/Code/User/globalStorage/ziglang.vscode-zig/zls_install/zls";
    };

    # Inline keybindings
    keybindings = [
      { key = "ctrl+t"; command = "workbench.action.togglePanel"; }
      # ... (all keybindings from keybindings.json)
    ];

    # Merged extensions (nixpkgs + marketplace)
    extensions = [
      # From existing module
      pkgs.vscode-extensions.golang.go
      pkgs.vscode-extensions.esbenp.prettier-vscode
      # ... (existing extensions)

      # From extensions.txt (marketplace)
      pkgs.vscode-marketplace.danielpriestley.poimandres-alternate
      pkgs.vscode-marketplace.yoavbls.pretty-ts-errors
      # ... (marketplace extensions)
    ];
  };
}
```

### 5. OpenCode Module (`modules/home-manager/opencode/default.nix`)

Copy `opencode.json` from `../dotfiles/opencode/` into the module directory:

```nix
{ ... }:
{
  xdg.configFile."opencode/opencode.json".source = ./opencode.json;
}
```

### 6. Machine home.nix Updates

For physical machines (beelink-ser8, surface-book-2):

```nix
imports = [
  ../shared/home.nix
  # REMOVE: ../../modules/home-manager/dotfiles
  ../../modules/home-manager/nvim          # NEW
  ../../modules/home-manager/developer
  ../../modules/home-manager/zsh
  ../../modules/home-manager/starship
  ../../modules/home-manager/shell
  ../../modules/home-manager/ghostty
  ../../modules/home-manager/wezterm       # NEW
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
  ../../modules/home-manager/opencode      # NEW
  ../../modules/home-manager/vs-code       # (already exists)
];

# REMOVE: dotfiles.enable = true;
nvim.enable = true;
zsh-custom.enable = true;
wezterm.enable = true;
opencode.enable = true;
```

For VMs (vm-intel, vm-aarch64, etc.):

```nix
imports = [
  ../shared/home.nix
  # REMOVE: ../../modules/home-manager/dotfiles
  ../../modules/home-manager/nvim          # NEW
  ../../modules/home-manager/developer
  ../../modules/home-manager/opencode      # NEW
];

# REMOVE: dotfiles.enable = true;
nvim.enable = true;
opencode.enable = true;
```

### 7. Flake Changes

Remove from `flake.nix`:

```nix
# REMOVE these lines:
dotfiles.url = "github:ChrisWrenDev/dotfiles";
dotfiles.inputs.nixpkgs.follows = "nixpkgs";
```

## Migration Order

1. Copy `nvim/` directory from `../dotfiles/nvim/` into repo root
2. Copy `opencode.json` from `../dotfiles/opencode/` into `modules/home-manager/opencode/`
3. Create `modules/home-manager/nvim/default.nix`
4. Create `modules/home-manager/opencode/default.nix`
5. Create `modules/home-manager/wezterm/default.nix` (migrate from `.wezterm.lua`)
6. Expand `modules/home-manager/zsh/default.nix` (inline `.zshrc` content)
7. Expand `modules/home-manager/vs-code/default.nix` (inline settings + keybindings)
8. Move `programs.wezterm.enable` from `developer/default.nix` to `wezterm/default.nix`
9. Update all machine `home.nix` files (remove dotfiles, add new modules)
10. Delete `modules/home-manager/dotfiles/default.nix`
11. Remove `dotfiles` input from `flake.nix`
12. Run `validate.sh` to check syntax
13. Rebuild and test

## Verification

1. `nix flake check` passes
2. `nixos-rebuild switch` succeeds on beelink-ser8
3. All tools launch with correct config:
   - Neovim loads all plugins and settings via `~/.config/nvim`
   - tmux uses C-Space prefix (from `tmux-custom`, no conflict with removed dotfiles)
   - zsh has all aliases, history, integrations (FZF, starship, mise)
   - WezTerm shows Tokyo Night theme, MesloLGS font, RESIZE decorations
   - VS Code has settings, keybindings, extensions
   - OpenCode loads `opencode.json` from `~/.config/opencode/`
4. Theme switching still works (FZF colors in zsh should update via `theme.colorsHex`)
5. No `dotfiles` references remain in the codebase
6. `flake.lock` updates correctly after removing dotfiles input
