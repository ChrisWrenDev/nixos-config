{
  config,
  lib,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  isWSL = config._module.args.isWSL or false;
in
{
  imports = [
    ./rust.nix
    ./go.nix
    ./python.nix
    ./zig.nix
    ./nix.nix
    ./tooling.nix
  ];

  options.developer = {
    enable = lib.mkEnableOption "developer environment with common tools";
  };

  config = lib.mkIf config.developer.enable {
    home.packages = []
    ++ (lib.optionals (isLinux && !isWSL) [
      pkgs.brightnessctl
      pkgs.playerctl
      pkgs.pavucontrol
      pkgs.nautilus
    ]);

    #-------------------------------------------------------------------
    # Neovim
    #-------------------------------------------------------------------

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      withPython3 = true;
      withNodeJs = true;
      extraPackages = with pkgs; [
        (vimPlugins.nvim-treesitter.withAllGrammars)
      ];
    };

    #-------------------------------------------------------------------
    # Shell
    #-------------------------------------------------------------------

    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    #-------------------------------------------------------------------
    # Languages
    #-------------------------------------------------------------------

    programs.go = {
      enable = true;
      goPath = "code/go";
    };

    #-------------------------------------------------------------------
    # Direnv
    #-------------------------------------------------------------------

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
