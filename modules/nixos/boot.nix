{
  config,
  pkgs,
  lib,
  ...
}: {
  # Boot loader defaults for Linux machines
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 3;
}
