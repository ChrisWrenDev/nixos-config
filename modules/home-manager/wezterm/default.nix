{ config, lib, pkgs, ... }:
let
  cfg = config.programs.wezterm-custom;
  theme = config.theme.colorsHex;
in
{
  options.programs.wezterm-custom = {
    enable = lib.mkEnableOption "WezTerm terminal configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;

      extraConfig = ''
        local wezterm = require("wezterm")
        local config = wezterm.config_builder()

        config.color_scheme = "TokyoNight"

        config.colors = {
          foreground = "${theme.foreground}",
          background = "${theme.background}",
          cursor_bg = "${theme.cursor}",
          cursor_fg = "${theme.background}",
          selection_bg = "${theme.selection_background}",
          selection_fg = "${theme.selection_foreground}",
          ansi = {
            "${theme.color0}",
            "${theme.color1}",
            "${theme.color2}",
            "${theme.color3}",
            "${theme.color4}",
            "${theme.color5}",
            "${theme.color6}",
            "${theme.color7}",
          },
          brights = {
            "${theme.color8}",
            "${theme.color9}",
            "${theme.color10}",
            "${theme.color11}",
            "${theme.color12}",
            "${theme.color13}",
            "${theme.color14}",
            "${theme.color15}",
          },
        }

        config.font = wezterm.font("MesloLGS Nerd Font Mono")
        config.font_size = 18

        config.hide_tab_bar_if_only_one_tab = true

        config.scrollback_lines = 3500
        config.enable_scroll_bar = true

        config.window_decorations = "RESIZE"

        return config
      '';
    };
  };
}
