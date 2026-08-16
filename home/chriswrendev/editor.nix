{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Neovim as the default editor, configured from the bundled `nvim/` config.
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

  xdg.configFile."nvim".source = ../../nvim;

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-tty;
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  programs.gpg.enable = true;
}
