# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{
  nixpkgs,
  overlays,
  inputs,
}: name: {
  system,
  user,
  darwin ? false,
  wsl ? false,
}: let
  # True if this is a WSL system.
  isWSL = wsl;

  # True if Linux, which is a heuristic for not being Darwin.
  isLinux = !darwin && !isWSL;

  # The config files for this system.
  machineConfig = ../machines/${name};
  userHMConfig = ../machines/${name}/home.nix;

  # NixOS vs nix-darwin functionst
  systemFunc =
    if darwin
    then inputs.darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;
  home-manager =
    if darwin
    then inputs.home-manager.darwinModules
    else inputs.home-manager.nixosModules;
in
  systemFunc rec {
    inherit system;

    modules = [
      # Apply our overlays. Overlays are keyed by system type so we have
      # to go through and apply our system type. We do this first so
      # the overlays are available globally.
      {nixpkgs.overlays = overlays;}

      # Allow unfree packages.
      {nixpkgs.config.allowUnfree = true;}

      # Bring in WSL if this is a WSL build
      (
        if isWSL
        then inputs.nixos-wsl.nixosModules.wsl
        else {}
      )

      # Snapd on Linux
      (
        if isLinux
        then inputs.nix-snapd.nixosModules.default
        else {}
      )

      machineConfig

      home-manager.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.${user} = import userHMConfig {
          username = user;
          isWSL = isWSL;
          inputs = inputs;
          pkgs = nixpkgs;
        };
      }

      # We expose some extra arguments so that our modules can parameterize
      # better based on these values.
      {
        config._module.args = {
          currentSystem = system;
          currentSystemName = name;
          currentSystemUser = user;
          isWSL = isWSL;
          inputs = inputs;
        };
      }
    ];
  }
