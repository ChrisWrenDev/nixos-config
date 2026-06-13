{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.btop-custom;
in
{
  options.programs.btop-custom = {
    enable = lib.mkEnableOption "Btop system monitor";
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      update_ms = 1000;
      presets = "cpu:0:default mem:0:default net:0:default";
      vim_keys = true;
      show_gpu = true;
      show_io_stat = true;
      color_theme = "tty";
    };
  };
  };
}
