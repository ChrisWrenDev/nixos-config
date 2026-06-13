{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.hypridle-custom;
in
{
  options.services.hypridle-custom = {
    enable = lib.mkEnableOption "Hypridle idle management";
  };

  config = lib.mkIf cfg.enable {
    services.hypridle = {
    enable = true;

    settings = {
      lock_cmd = "hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      inhibit_sleep = 3;

      listener = [
        # Screensaver after 2.5 minutes
        {
          timeout = 150;
          on-timeout = "pidof hyprlock || hyprdispatcher flicker";
        }
        # Lock screen after 5 minutes
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        # Turn off display after 5.5 minutes
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # Suspend after 30 minutes
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
  };
}
