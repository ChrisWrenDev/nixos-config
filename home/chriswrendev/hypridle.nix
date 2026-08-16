{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.hypridle = {
    enable = true;

    settings = {
      lock_cmd = "hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      inhibit_sleep = 3;

      listener = [
        # Idle behavior matching Omarchy: screensaver ~2.5min, lock at 5min,
        # display off right after, suspend at 30min.
        {
          timeout = 150;
          on-timeout = "pidof hyprlock || hyprctl dispatch dpms on";
        }
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
