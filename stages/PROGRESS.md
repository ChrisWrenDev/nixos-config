# Migration Progress

Track completion of each stage. Mark items as done when completed.

## Stage 1: Theme Foundation
- [x] Add `nix-colors` to `flake.nix` inputs
- [x] Create `themes/tokyo-night.nix`
- [x] Create `themes/catppuccin.nix`
- [x] Create `themes/gruvbox.nix`
- [x] Create `themes/nord.nix`
- [x] Create remaining 17 theme files
- [x] Create `modules/home-manager/theme/default.nix`
- [x] Update `starship/default.nix` to use theme colors
- [x] Update `shared/home.nix` to import theme module
- [x] Update both machine `home.nix` files
- [ ] Run `nix flake check`
- [ ] Build and verify on beelink-ser8

## Stage 2: Terminal & Shell
- [x] Create `modules/home-manager/ghostty/default.nix`
- [x] Create `modules/home-manager/shell/default.nix`
- [x] Update `shared/home.nix` with required packages
- [x] Update both machine `home.nix` files
- [ ] Test Ghostty launches with theme colors
- [ ] Verify aliases work

## Stage 3: Hyprland Desktop
- [x] Update `modules/nixos/x86_64-linux.nix` (remove KDE, add Hyprland)
- [x] Create `modules/home-manager/hyprland/default.nix`
- [x] Create `modules/home-manager/hyprland/autostart.nix`
- [x] Create `modules/home-manager/hyprland/bindings.nix`
- [x] Create `modules/home-manager/hyprland/looknfeel.nix`
- [x] Create `modules/home-manager/hyprland/windows.nix`
- [x] Create `modules/home-manager/waybar/default.nix`
- [x] Update both machine `home.nix` files
- [ ] Test Hyprland starts correctly
- [ ] Verify keybindings work
- [ ] Test Waybar with theme colors

## Stage 4: Supporting Services
- [x] Create `modules/home-manager/mako/default.nix`
- [x] Create `modules/home-manager/hyprlock/default.nix`
- [x] Create `modules/home-manager/hypridle/default.nix`
- [x] Create `modules/home-manager/walker/default.nix`
- [x] Create `modules/home-manager/swayosd/default.nix`
- [x] Update both machine `home.nix` files
- [ ] Test notifications
- [ ] Test screen lock
- [ ] Test idle management
- [ ] Test Walker app launcher
- [ ] Test SwayOSD overlays

## Stage 5: Dotfiles & Polish
- [x] Create `modules/home-manager/git/default.nix`
- [x] Create `modules/home-manager/tmux/default.nix`
- [x] Create `modules/home-manager/btop` with theme
- [x] Create `modules/home-manager/fastfetch/default.nix`
- [x] Create `scripts/theme-switch`
- [x] Create `scripts/screenshot`
- [x] Update `developer/default.nix` (remove tmux, add packages)
- [x] Update both machine `home.nix` files
- [ ] Final integration test on beelink-ser8
- [ ] Final integration test on surface-book-2
- [ ] Clean up old KDE references

## Stage 6: Dotfiles to Nix Migration
- [x] Copy `nvim/` directory from `../dotfiles/nvim/` into repo
- [x] Copy `opencode.json` from `../dotfiles/opencode/` into module
- [x] Create `modules/home-manager/nvim/default.nix`
- [x] Create `modules/home-manager/opencode/default.nix`
- [x] Create `modules/home-manager/wezterm/default.nix`
- [x] Expand `modules/home-manager/zsh/default.nix`
- [x] Expand `modules/home-manager/vs-code/default.nix`
- [x] Move `programs.wezterm.enable` from `developer` to `wezterm` module
- [x] Update all machine `home.nix` files
- [x] Delete `modules/home-manager/dotfiles/default.nix`
- [x] Remove `dotfiles` input from `flake.nix`
- [ ] Run `validate.sh`
- [ ] Rebuild and test on beelink-ser8
- [ ] Rebuild and test on surface-book-2
