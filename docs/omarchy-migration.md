# Omarchy → NixOS Migration Notes

This document describes how Omarchy's desktop experience has been translated
into the declarative NixOS + Home Manager configuration in this repository. It
is **not** a literal port of Omarchy: Omarchy is Arch-based and leans on a large
`omarchy-*` command suite and imperative configuration mutation. Here the
equivalent behaviour is expressed through NixOS/Home Manager options and native
Hyprland config.

Classification legend:

- **KEEP** — reproduced directly (startup/shortcut/app choices carry over).
- **REIMPLEMENT** — same intent, native implementation in Nix / Hyprland.
- **REPLACE** — Omarchy's mechanism is Arch/Quickshell-specific; a clean native
  equivalent takes its place.
- **DROP** — Omarchy only had it to mutate an Arch system; not needed on NixOS.
- **DEFER** — recognized, intentionally left for a later iteration.

## Component mapping

| Component | Omarchy implementation | Desired behaviour | NixOS/Home Manager implementation | Status |
| --- | --- | --- | --- | --- |
| Hyprland config | Lua (`default/hypr/*.lua`) + `config/hypr/*.lua` | Tiling WM with dwindle layout | `home/chriswrendev/hyprland.nix` (`wayland.windowManager.hyprland.settings`) | KEEP |
| Keybindings | `default/hypr/bindings/*.lua` (Lua helpers) | Same shortcuts | `home/chriswrendev/hyprland.nix` `bind` list | REIMPLEMENT |
| Session start | Quickshell (bar + menu + notifications all in one process) | Waybar/mako/walker at login | Hyprland `exec-once` in `home/chriswrendev/hyprland.nix` | REPLACE |
| Top bar | Quickshell bar (`shell/plugins/bar`) | Status bar, workspace indicators, tray, audio/network | Waybar (`home/chriswrendev/waybar.nix`) | REPLACE |
| Menu / launcher | Quickshell menu (`omarchy-menu`) | App launcher + command menu | Walker (`home/chriswrendev/walker.nix`) | REPLACE |
| Notifications | Quickshell notifications | Toasts, do-not-disturb actions | Mako (`home/chriswrendev/mako.nix`) | REPLACE |
| Clipboard history | Quickshell clipboard plugin | Copy/paste history (text + images) | Walker clipboard mode + cliphist | REPLACE |
| Lock screen | Quickshell lock plugin (PAM `omarchy-lock-password`) | Password lock on idle/lock key | Hyprlock (`home/chriswrendev/hyprlock.nix`) + `security.pam.services.hyprlock` | REPLACE |
| Idle handling | `shell.json` idle: screensaver 150s, lock 300s | Idle lock + dpms + suspend | Hypridle (`home/chriswrendev/hypridle.nix`) | KEEP |
| Power menu | Quickshell power panel | Suspend / reboot / shutdown menu | Wlogout (bound to `SUPER, Escape`) | REPLACE |
| Audio controls | `omarchy-audio-*` + OSD | Volume keys, mute, per-app mixer | SwayOSD + pamixer/pavucontrol | REIMPLEMENT |
| Brightness | `omarchy-brightness-display` | Brightness keys + OSD | brightnessctl (+ SwayOSD OSD) | REIMPLEMENT |
| Media controls | `omarchy-shell media *` (MPRIS) | Play/pause/next/prev | playerctl | REIMPLEMENT |
| Screenshots | `omarchy-capture-screenshot` (grim+slurp) | Region/fullscreen screenshots to clipboard | grim + slurp + wl-copy binds | KEEP |
| Color picker | `hyprpicker -a` | Pick color to clipboard | `hyprpicker -a` binding | KEEP |
| Terminal | Foot/ghostty/kitty (theme templates) | Default terminal, themed | Ghostty + WezTerm (`home/chriswrendev/terminal.nix`) | KEEP |
| Shell | bash (aliases + functions + starship) | zsh, aliases, functions, prompt | zsh + starship + `shell-functions.sh` | REIMPLEMENT |
| Fonts | JetBrainsMono Nerd Font + Liberation fallbacks | Terminal & system font | `fonts.packages` + fontconfig aliases | KEEP |
| Theme colours | `colors.toml` per theme + templates | Tokyo Night as default | `themes/*.nix` + `home/chriswrendev/theme.nix` | REIMPLEMENT |
| Theme switching | `omarchy-theme-*` (regenerates templates + shell) | Pick theme in Nix, rebuild | `theme.active` option in `home/chriswrendev/default.nix` | REIMPLEMENT |
| Wallpaper | theme `backgrounds/` | Tokyo Night winding-road image | `wallpapers/tokyo-night.jpg` via `home.file` + swaybg | KEEP |
| Default apps | `default/applications/mimeapps.list` | Default browser/files/images etc | `home/chriswrendev/packages.nix` `xdg.mimeApps` | KEEP |
| File manager | Nautilus | Files browsing | Nautilus | KEEP |
| Git | git aliases + lazygit | Configured git + lazygit | `home/chriswrendev/git.nix`, lazygit in developer.nix | KEEP |
| Editor | Neovim (LazyVim flavored) | Configured nvim (user dotfiles) | `home/chriswrendev/editor.nix` (bundled `nvim/` dir) | KEEP |
| CLI tools | bat/eza/fd/fzf/ripgrep/jq/tldr | Same default CLI set | `home/chriswrendev/packages.nix` | KEEP |
| Polkit agent | Quickshell polkit agent | Auth prompt on privilege | polkit-gnome agent | REPLACE |
| XDG portals | xdg-desktop-portal-hyprland + gtk | Screen share, file dialogs | `modules/desktop/default.nix` | KEEP |
| Networking UX | nm-applet + panels | Tray wifi + nm-connection-editor | nm-applet in Hyprland autostart | REPLACE |
| Bluetooth UX | blueman + panels | Tray bluetooth + manager | blueman-applet + blueman-manager | REPLACE |
| Autostart services | Quickshell + `omarchy-launch-shell` | Idle, notifications, bar, polkit, trays at login | Hyprland `exec-once` | REIMPLEMENT |
| Input method | fcitx5 | Multi-layout input | fcitx5 autostart (see notes) | DEFER |
| Screen recording | `gpu-screen-recorder` | Alt+Print recording w/ webcam | not yet configured | DEFER |
| OCR | `tesseract` text extraction | Super+Ctrl+Print OCR | not yet configured | DEFER |
| Reminders | Quickshell reminders plugin | Set/show reminders | not yet configured | DEFER |
| Web apps | webapp installers (HEY, Discord…) | Web app shortcuts | manual / later | DEFER |
| Dictation | voxtype | Voice dictation | not yet configured | DEFER |
| `omarchy-*` commands | Full command suite | Maintenance/mutation commands on Arch | not needed — Nix handles this | DROP |
| Combine/alter packages | `omarchy-pkg-*` / AUR | Install/remove software | Nix flake / home.packages | DROP |
| Update pipeline | `omarchy-update-*` | Upgrade the system | `nixos-rebuild switch` | DROP |
| Theme install/regenerate | `omarchy-theme-install` etc | Change theme at runtime | change `theme.active`, rebuild | DROP |
| Snapshots | snapper | System snapshots | not configured (could use btrfs/zfs) | DEFER |

## Notes on notable decisions

- **Shell: zsh.** Omarchy is bash-only, but this user's existing setup is zsh.
  The zsh config ports Omarchy's aliases, functions (`open`, `eff`, `compress`,
  `tdl`, `ga`, `gd`, `fip`/`dip`/`lip`) and environment.
- **Cursor**: Bibata Modern Classic (24px) for both X11 and Hyprland cursors.
- **GTK/Qt**: dark GTK (Adwaita-dark base with theme colors via `extraCss`),
  Qt apps forced through the GTK platform theme (`QT_QPA_PLATFORMTHEME=gtk3`).
- **Terminal: ghostty + wezterm.** The previous config enabled both; retained
  as-is (Omarchy's default is foot, but the user asked to keep both).
- **Clipboard**: `wl-clipboard` provides the unified copy/paste
  (`SUPER C/X/V`); clipboard history (`SUPER CTRL, V`) uses Walker 2.x +
  **elephant** (its `clipboard` provider replaces the older cliphist approach,
  which has been dropped to keep one clipboard backend).
- **Power menu**: `SUPER, Escape` opens Wlogout (suspend/reboot/shutdown/logout).
- **Idle** follows Omarchy: screensaver ~2.5 min, lock ~5 min, display off,
  suspend at 30 min.
- **Screen share picker**: the old repo had a themed
  `hyprland-preview-share-picker.css`, retained for xdg-desktop-portal-gnome
  screen-share dialogs.

## Deferred (in more detail)

1. **Screen recording** — Omarchy uses `gpu-screen-recorder` with post-process;
   needs the tool + webcam handling commit to this config.
2. **OCR** — `tesseract` + capture pipeline.
3. **Input method (fcitx5)** — could be re-enabled for non-Latin layouts.
4. **Reminders / weather / notices** — Quickshell plugins; out of scope until
   the core is rock solid.
5. **Dynamic theme switching** — currently `theme.active` = one rebuild-aware
   theme. A `theme-set` helper that edits `theme.active` + rebuilds is
   theoretically possible and documented here for later.
6. **Surface Book 2** — see the separate architecture notes; purely a new
   `hosts/surface-book-2/` directory.

## Surface Book 2 readiness

The configuration is structured so a second host is a pure addition:

- `flake.nix` builds hosts via `mkHost "beelink-ser8"`; adding
  `surface-book-2` is one more entry picking `hosts/surface-book-2`.
- All home-manager desktop configuration lives in `home/chriswrendev/` and is
  imported by the flake for *every* host, so the desktop is ~100% shared.
- Host-specific concerns are kept out of the shared desktop:
  `hosts/beelink-ser8/hardware-configuration.nix` (UUIDs) and
  `modules/desktop/*` (session, Wayland backend) are the only SER8-specific
  bits; the shared Hyprland config contains no monitor/workspace assumptions.
- To add Surface Book 2 later you would:
  1. Add a `hosts/surface-book-2/{default.nix,hardware-configuration.nix}`.
  2. Enable `nixos-hardware`'s `microsoft/surface-book-2` profile (or a custom
     Surface kernel) in that host.
  3. Set per-host monitor/scale overrides in the host file (not in shared
     `home/chriswrendev/hyprland.nix`).
  4. Add any hybrid-GPU/NVIDIA/suspend specifics to the host or a
     `modules/hardware/surface.nix`.

No restructuring is required to support it.

## Credential notes

The previous `machines/shared` config contained a committed password hash and
SSH public key. Per security guidance the plaintext hash has been removed;
with the default `users.mutableUsers = true`, NixOS leaves `/etc/shadow` alone,
so the password set with `passwd` during install keeps working. `sudo` is
passwordless for the `wheel` group, so on a fresh machine you can recover with:

```bash
sudo passwd chriswrendev
```

The SSH **public** key is intentionally kept in `modules/system/base.nix` (it is
public by nature). If you want it gone from the repo too, that's a one-line
removal.
