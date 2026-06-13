{ config, pkgs, lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")

    ./hardware.nix
    ../shared
    ../../modules/nixos/parallels-guest.nix
  ];

  # Disable nixpkgs built-in — our custom module from parallels-guest.nix is used instead
  disabledModules = [ "virtualisation/parallels-guest.nix" ];

  hardware.parallels = {
    enable = true;
    package = (config.boot.kernelPackages.callPackage ../../pkgs/parallels-tools/default.nix { });
  };

  # Interface is this on my M1
  networking.interfaces.enp0s5.useDHCP = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnsupportedSystem = true;

  system.stateVersion = "24.11";
}
