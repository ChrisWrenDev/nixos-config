# Migration Overview

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        flake.nix                            │
│  inputs: nixpkgs, home-manager, nix-colors, ghostty, ...   │
│  outputs: nixosConfigurations.{beelink,surface}             │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    modules/nixos/                            │
│  x86_64-linux.nix: Hyprland, SDDM (Wayland), PipeWire,    │
│                    Bluetooth, Fonts, Packages               │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                  modules/home-manager/                       │
│                                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  theme   │  │ hyprland │  │  ghostty │  │  waybar  │   │
│  │(nix-colors)│ │bindings  │  │  colors  │  │  colors  │   │
│  │  colors  │  │autostart │  │  font    │  │  modules │   │
│  └────┬─────┘  │looknfeel │  └──────────┘  └──────────┘   │
│       │        │windows   │                                 │
│       │        └──────────┘                                 │
│       │                                                     │
│  ┌────▼─────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  shell   │  │  hyprlock│  │  mako    │  │  walker  │   │
│  │ aliases  │  │  theme   │  │  colors  │  │  theme   │   │
│  │ functions│  │  clock   │  │  layout  │  │  search  │   │
│  └──────────┘  │  blur    │  └──────────┘  └──────────┘   │
│                └──────────┘                                 │
│                                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  hypridle│  │  tmux    │  │  btop    │  │  fastfetch│  │
│  │  lock    │  │  prefix  │  │  theme   │  │  system  │   │
│  │  dim     │  │  vi-mode │  │  vim     │  │  info    │   │
│  │  suspend │  │  status  │  └──────────┘  └──────────┘   │
│  └──────────┘  └──────────┘                                 │
│                                                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                  │
│  │  swayosd │  │  git     │  │  starship│                  │
│  │  volume  │  │  delta   │  │  colors  │                  │
│  │  bright  │  │  signing │  │  modules │                  │
│  └──────────┘  └──────────┘  └──────────┘                  │
└─────────────────────────────────────────────────────────────┘
```

## What We're Taking from Omarchy

| Component | Source | NixOS Destination |
|-----------|--------|-------------------|
| 21 color themes | `themes/*/colors.toml` | `themes/*.nix` (Nix attrsets) |
| Ghostty config | `config/ghostty/config` | `modules/home-manager/ghostty/` |
| Hyprland config | `default/hypr/*.lua` | `modules/home-manager/hyprland/` |
| Waybar config | `config/waybar/` | `modules/home-manager/waybar/` |
| Hyprlock/Hypridle | `config/hypr/hypr*.conf` | `modules/home-manager/hypr*/` |
| Mako config | `default/mako/core.ini` | `modules/home-manager/mako/` |
| Walker config | `config/walker/config.toml` | `modules/home-manager/walker/` |
| SwayOSD config | `config/swayosd/config.toml` | `modules/home-manager/swayosd/` |
| Bash aliases/functions | `default/bash/aliases,functions` | `modules/home-manager/shell/` |
| Starship colors | `config/starship.toml` | `modules/home-manager/starship/` |
| Git config | `config/git/config` | `modules/home-manager/git/` |
| Tmux config | `config/tmux/tmux.conf` | `modules/home-manager/tmux-custom/` |
| Btop config | `config/btop/btop.conf` | `modules/home-manager/btop/` |
| Fastfetch config | `config/fastfetch/config.jsonc` | `modules/home-manager/fastfetch/` |

## What We're Replacing

| Current | Omarchy | NixOS Equivalent |
|---------|---------|-------------------|
| KDE Plasma 6 | Hyprland | `programs.hyprland.enable` |
| SDDM (X11) | SDDM (Wayland) | `services.displayManager.sddm.wayland.enable` |
| WezTerm | Ghostty | `programs.ghostty` |
| Manual dotfiles | omarchy-* commands | Home Manager modules |
| No theme system | Template engine | nix-colors + theme module |

## Omarchy Commands → NixOS Equivalents

| Omarchy Command | NixOS Equivalent |
|-----------------|------------------|
| `omarchy-theme-set <name>` | `scripts/theme-switch <name>` |
| `omarchy-toggle-waybar` | `pkill waybar \|\| waybar` |
| `omarchy-toggle-idle` | `pkill hypridle \|\| hypridle` |
| `omarchy-toggle-nightlight` | `hyprsunset -t 4000` |
| `omarchy-swayosd-client` | `swayosd-client` |
| `omarchy-snapshot` | N/A (not applicable) |
| `omarchy-capture-screenrecording` | `wf-recorder` |
| `omarchy-snapshot` | `grim -g "$(slurp)"` |
| `omarchy-launch-walker` | `walker` |
| `omarchy-launch-audio` | `pavucontrol` |
| `omarchy-launch-tui` | `ghostty -e <command>` |
| `omarchy-refresh-hyprland` | `nixos-rebuild switch` |
| `omarchy-restart-tmux` | `tmux kill-server && tmux` |

## Files NOT Being Migrated

These are intentionally excluded:

- `bin/omarchy-*` (306 scripts) — Reimplemented as NixOS-native equivalents
- `install/` — Arch-specific, replaced by NixOS package management
- `migrations/` — Version-specific, not applicable
- `applications/` — Desktop entries handled by NixOS/Flatpak
- `default/sddm/` — Omarchy SDDM theme (using NixOS defaults)
- `default/plymouth/` — Boot splash (optional future addition)
- `config/lazygit/config.yml` — Empty (uses defaults)
- `config/omarchy/hooks/` — Omarchy-specific hook system
