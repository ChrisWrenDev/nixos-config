{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ghostty-custom;
  theme = config.theme.colorsHex;
in
{
  options.programs.ghostty-custom = {
    enable = lib.mkEnableOption "Ghostty terminal configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
    };

    xdg.configFile."ghostty/config".text = ''
    # Font
    font-family = JetBrainsMono Nerd Font
    font-style = Regular
    font-size = 9

    # Window
    window-theme = dark
    window-padding-x = 14
    window-padding-y = 14
    confirm-close-surface = false
    resize-overlay = never

    # Cursor
    cursor-style = block
    cursor-style-blink = false

    # Shell integration
    shell-integration-features = no-cursor,ssh-env

    # Background/foreground
    background = ${theme.background}
    foreground = ${theme.foreground}
    cursor-color = ${theme.cursor}
    selection-foreground = ${theme.selection_foreground}
    selection-background = ${theme.selection_background}

    # Terminal colors (normal)
    palette = 0=${theme.color0}
    palette = 1=${theme.color1}
    palette = 2=${theme.color2}
    palette = 3=${theme.color3}
    palette = 4=${theme.color4}
    palette = 5=${theme.color5}
    palette = 6=${theme.color6}
    palette = 7=${theme.color7}

    # Terminal colors (bright)
    palette = 8=${theme.color8}
    palette = 9=${theme.color9}
    palette = 10=${theme.color10}
    palette = 11=${theme.color11}
    palette = 12=${theme.color12}
    palette = 13=${theme.color13}
    palette = 14=${theme.color14}
    palette = 15=${theme.color15}

    # Keybindings
    keybind = shift+insert=paste_from_clipboard
    keybind = control+insert=copy_to_clipboard
    keybind = super+control+shift+alt+arrow_down=resize_split:down,100
    keybind = super+control+shift+alt+arrow_up=resize_split:up,100
    keybind = super+control+shift+alt+arrow_left=resize_split:left,100
    keybind = super+control+shift+alt+arrow_right=resize_split:right,100

    # Mouse
    mouse-scroll-multiplier = 0.95
  '';
  };
}
