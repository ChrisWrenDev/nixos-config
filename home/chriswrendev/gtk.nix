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
  # GTK/Qt theming matching the active Omarchy theme (dark, accent border).
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    gtk3.extraCss = ''
      @define-color accent #${theme.accent};
      @define-color foreground #${theme.foreground};
      @define-color background #${theme.background};

      window {
        background-color: @background;
        color: @foreground;
      }
      button {
        color: @foreground;
      }
      entry, spinbutton, combobox {
        color: @foreground;
        background-color: #${theme.color0};
      }
      selection {
        background-color: @accent;
        color: #${theme.background};
      }
    '';

    gtk4.extraCss = ''
      @define-color accent #${theme.accent};
      @define-color foreground #${theme.foreground};
      @define-color background #${theme.background};

      window {
        background-color: @background;
        color: @foreground;
      }
      button {
        color: @foreground;
      }
      entry, spinbutton, combobox {
        color: @foreground;
        background-color: #${theme.color0};
      }
      selection {
        background-color: @accent;
        color: #${theme.background};
      }
    '';
  };

  # Make Qt apps follow the same dark GTK theme.
  qt.enable = true;
  qt.platformTheme.name = "gtk3";
}
