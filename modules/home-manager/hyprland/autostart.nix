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
      exec-once = [
        # Idle management
        "uwsm-app -- hypridle"
        # Notification daemon
        "uwsm-app -- mako"
        # Status bar
        "uwsm-app -- waybar"
        # Input method
        "uwsm-app -- fcitx5 --disable notificationitem"
        # Wallpaper
        "uwsm-app -- swaybg -m fill -i ${config.home.homeDirectory}/.config/hypr/wallpaper.png"
        # Volume/brightness OSD
        "uwsm-app -- swayosd-server"
        # Polkit authentication agent
        "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
        # Network manager tray icon
        "uwsm-app -- nm-applet --indicator"
        # Bluetooth tray icon
        "uwsm-app -- blueman-applet"
        # Import systemd environment
        "systemctl --user import-environment $(env | cut -d'=' -f 1)"
        "dbus-update-activation-environment --systemd --all"
      ];
    };
  };
}
