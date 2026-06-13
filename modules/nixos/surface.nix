{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hardware.surface;
in {
  options.hardware.surface = {
    enable = lib.mkEnableOption "Microsoft Surface hardware support (linux-surface kernel, touchscreen, pen, sensors)";
  };

  config = lib.mkIf cfg.enable {
    # Use the stable kernel track
    hardware.microsoft-surface.kernelVersion = "stable";

    # Touchscreen and pen support (Intel Precise Touch & Stylus)
    services.iptsd = {
      enable = true;
      config = {
        Touchscreen = {
          DisableOnPalm = true;
          DisableOnStylus = true;
        };
      };
    };

    # Surface control CLI (performance modes, dGPU, battery, DTX)
    environment.systemPackages = with pkgs; [
      surface-control
      libwacom-surface
    ];

    # udev rules for iptsd and surface-control
    services.udev.packages = with pkgs; [
      iptsd
      surface-control
    ];

    # IIO sensors (accelerometer, ambient light sensor)
    hardware.sensor.iio.enable = true;

    # S0ix Modern Standby
    boot.kernelParams = ["mem_sleep_default=deep"];

    # TLP causes issues on Surface devices
    services.tlp.enable = lib.mkForce false;

    # Add user to surface-control group
    users.groups.surface-control = {};
    users.users.chriswrendev.extraGroups = ["surface-control"];
  };
}
