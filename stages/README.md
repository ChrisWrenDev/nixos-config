# Omarchy → NixOS Migration

Migrating the Omarchy desktop environment (Hyprland, themes, dotfiles) into the existing NixOS + Home Manager configuration.

## Target Machines
- `beelink-ser8` (x86_64-linux, AMD)
- `surface-book-2` (x86_64-linux, Intel)

## Key Decisions
- **Theme system:** nix-colors integration (not raw Omarchy template engine)
- **Desktop:** Replace KDE Plasma 6 with Hyprland
- **Terminal:** Ghostty (default), WezTerm kept as fallback
- **Scope:** Both physical x86_64-linux machines; VMs unchanged

## Stages

| Stage | Name | Description | Estimated Effort |
|-------|------|-------------|-----------------|
| [1](stage-1.md) | Theme Foundation | nix-colors, color definitions, template engine | Medium |
| [2](stage-2.md) | Terminal & Shell | Ghostty, bash aliases/functions, starship colors | Low |
| [3](stage-3.md) | Hyprland Desktop | Hyprland, Waybar, keybindings, autostart | High |
| [4](stage-4.md) | Supporting Services | Mako, Hyprlock/Idle, Walker, SwayOSD, toggles | Medium |
| [5](stage-5.md) | Dotfiles & Polish | Git, tmux, btop, fastfetch, screenshots, theme switching | Low |

## Architecture

```
nixos-config/
├── flake.nix                          # + nix-colors input
├── modules/
│   ├── home-manager/
│   │   ├── theme/default.nix          # NEW: Theme module (nix-colors)
│   │   ├── hyprland/default.nix       # NEW: Hyprland module
│   │   ├── ghostty/default.nix        # NEW: Ghostty module
│   │   ├── waybar/default.nix         # NEW: Waybar module
│   │   ├── shell/default.nix          # NEW: Shell aliases/functions
│   │   ├── starship/default.nix       # MODIFIED: Use theme colors
│   │   └── developer/default.nix      # MODIFIED: Add Omarchy tools
│   └── nixos/
│       └── x86_64-linux.nix           # MODIFIED: Replace KDE with Hyprland
└── themes/                            # NEW: Omarchy themes as Nix attrsets
    ├── tokyo-night.nix
    ├── catppuccin.nix
    └── ...
```
