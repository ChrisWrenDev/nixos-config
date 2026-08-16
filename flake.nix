{
  description = "NixOS + Home Manager configuration for the Beelink SER8, recreating the Omarchy desktop with native tools";

  inputs = {
    # Primary nixpkgs. 26.05 is the current stable and matches the base of the
    # freshly installed machine.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      user = "chriswrendev";

      # Where host-specific modules live so a future host (e.g. surface-book-2)
      # only needs a directory here to be added.
      mkHost = host: {
        modules = [
          ./hosts/${host}
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {
                inherit
                  self
                  nixpkgs
                  home-manager
                  host
                  user
                  inputs
                  ;
              };
              users.${user} = import ./home/${user};
            };
          }
        ];
        specialArgs = {
          inherit
            self
            nixpkgs
            home-manager
            user
            inputs
            ;
        };
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

      nixosConfigurations = {
        beelink-ser8 = nixpkgs.lib.nixosSystem (mkHost "beelink-ser8" // { system = "x86_64-linux"; });
      };
    };
}
