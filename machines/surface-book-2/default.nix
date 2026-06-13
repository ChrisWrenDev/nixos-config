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
    ../../modules/nixos/desktop.nix
  ];

  networking.hostName = "surface-book-2";

  system.stateVersion = "24.11";
}
