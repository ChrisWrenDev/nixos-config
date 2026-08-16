{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./theme.nix
    ./hyprland.nix
    ./waybar.nix
    ./walker.nix
    ./mako.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./swayosd.nix
    ./shell.nix
    ./git.nix
    ./tmux.nix
    ./terminal.nix
    ./editor.nix
    ./developer.nix
    ./packages.nix
  ];

  home.stateVersion = "26.05";

  home.username = "chriswrendev";
  home.homeDirectory = "/home/chriswrendev";

  # Pick the primary Omarchy appearance (Tokyo Night) declaratively. Change
  # this and rebuild to switch; there is no imperative theme mutator.
  theme.active = "tokyo-night";
}
