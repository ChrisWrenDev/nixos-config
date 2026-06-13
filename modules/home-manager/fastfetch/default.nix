{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.fastfetch-custom;
in
{
  options.programs.fastfetch-custom = {
    enable = lib.mkEnableOption "Fastfetch system info display";
  };

  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        separator = " -> ";
      };

      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "host"
        "uptime"
        "packages"
        "shell"
        "terminal"
        "de"
        "wm"
        "wmtheme"
        "separator"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "separator"
        "localip"
        "battery"
        "locale"
        "break"
        "colors"
      ];
    };
  };
  };
}
