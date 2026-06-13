{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.developer.enable {
    home.packages = with pkgs; [
      nixpkgs-fmt
      nil
      statix
      deadnix
      alejandra
      nix-output-monitor
      nixd
    ];
  };
}
