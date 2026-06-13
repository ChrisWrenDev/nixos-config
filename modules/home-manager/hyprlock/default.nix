{
  config,
  lib,
  pkgs,
  ...
}:
let
  theme = config.theme.colorsHex;
in
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        ignore_empty_input = true;
        hide_cursor = true;
      };

      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
        noise = 0.01;
        contrast = 0.9;
        brightness = 0.6;
        vibrancy = 0.2;
        vibrancy_darkness = 0.5;
      };

      animations = {
        enabled = false;
      };

      input-field = {
        monitor = "";
        size = "650, 100";
        outline_thickness = 4;
        dots_size = 0.25;
        dots_spacing = 0.15;
        dots_center = true;
        outer_color = theme.accent;
        inner_color = theme.color0;
        font_color = theme.foreground;
        fade_on_empty = false;
        placeholder_text = "Enter Password";
        check_color = theme.accent;
        fail_text = "<i>$FAIL ($ATTEMPTS)</i>";
        position = "0, 0";
        halign = "center";
        valign = "center";
        rounding = 0;
        shadow_passes = 0;
      };
    };
  };
}
