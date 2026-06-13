{ config, lib, ... }:
{
  options.programs.nvim-custom = {
    enable = lib.mkEnableOption "Neovim configuration from dotfiles";
  };

  config = lib.mkIf config.programs.nvim-custom.enable {
    xdg.configFile."nvim".source = ../../../nvim;
  };
}
