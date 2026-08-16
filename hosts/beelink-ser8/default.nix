{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/boot.nix
    ../../modules/system/base.nix
    ../../modules/desktop
  ];

  networking.hostName = "beelink-ser8";

  # Use appropriate AMD features for the Ryzen 7840 780M platform.
  hardware.graphics = {
    enable = true;
  };

  system.stateVersion = "26.05";
}
