{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      # Window rules
      windowrulev2 = [
        # Suppress maximize events globally
        "suppressevent maximize, class:.*"

        # Fix XWayland dragging issues
        "nofocus, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pinned:0"

        # App-specific overrides
        "float, class:^(pavucontrol)$"
        "float, class:^(blueman)$"
        "float, class:^(nm-applet)$"
        "float, class:^(gnome-calculator)$"
        "float, class:^(imv)$"
        "float, title:^(Picture-in-Picture)$"
        "float, title:^(Open File)$"
        "float, title:^(Save As)$"
        "float, title:^(Confirm)$"
        "opacity 0.97 0.9, tag:default-opacity"
      ];
    };
  };
}
