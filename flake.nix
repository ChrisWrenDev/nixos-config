{
  description = "ChrisWrenDev NixOS Configuration";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Build a custom WSL installer
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # snapd
    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    # Color schemes for theming
    nix-colors.url = "github:misterio77/nix-colors";

    # Other packages
    nur.url = "github:nix-community/nur";
    zig.url = "github:mitchellh/zig-overlay";

    # Hardware-specific modules (Surface, etc.)
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Voice dictation
    voxtype = {
      url = "github:peteonrails/voxtype/v1.0.0-rc1";
    };

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ...
  } @ inputs: let
    # Overlays is the list of overlays we want to apply from flake inputs.
    overlays = [
      inputs.zig.overlays.default
      inputs.nix-vscode-extensions.overlays.default

      (final: prev: rec {
        # gh CLI on stable has bugs.
        gh = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.gh;
      })
    ];

    mkSystem = import ./lib/mksystem.nix {
      inherit overlays nixpkgs inputs;
    };
  in {
    # Export lib for external use
    lib = { inherit mkSystem; };

    # Primary hosts
    nixosConfigurations.beelink-ser8 = mkSystem "beelink-ser8" {
      system = "x86_64-linux";
      user = "chriswrendev";
    };

    nixosConfigurations.surface-book-2 = mkSystem "surface-book-2" {
      system = "x86_64-linux";
      user = "chriswrendev";
    };

    nixosConfigurations.thinkpad-wsl = mkSystem "thinkpad-wsl" {
      system = "x86_64-linux";
      user = "chriswrendev";
      wsl = true;
    };

    darwinConfigurations.macbook = mkSystem "macbook" {
      system = "aarch64-darwin";
      user = "chriswrendev";
      darwin = true;
    };

    # VMs
    nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
      system = "aarch64-linux";
      user = "chriswrendev";
    };

    nixosConfigurations.vm-aarch64-prl = mkSystem "vm-aarch64-prl" {
      system = "aarch64-linux";
      user = "chriswrendev";
    };

    nixosConfigurations.vm-aarch64-utm = mkSystem "vm-aarch64-utm" {
      system = "aarch64-linux";
      user = "chriswrendev";
    };

    nixosConfigurations.vm-intel = mkSystem "vm-intel" {
      system = "x86_64-linux";
      user = "chriswrendev";
    };
  };
}
