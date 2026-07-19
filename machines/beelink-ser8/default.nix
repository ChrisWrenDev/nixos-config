{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
    ../shared
    ../../modules/nixos/boot.nix
  #  ../../modules/nixos/desktop.nix
  ];

  networking.hostName = "beelink-ser8";

  system.stateVersion = "24.11";
}
