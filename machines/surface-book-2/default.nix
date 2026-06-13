{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware.nix
    ../shared
    ../../modules/nixos/boot.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/surface.nix
    inputs.nixos-hardware.nixosModules.microsoft-surface-common
  ];

  networking.hostName = "surface-book-2";

  hardware.surface.enable = true;

  system.stateVersion = "24.11";
}
