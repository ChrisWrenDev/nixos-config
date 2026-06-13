{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.swayosd;
  theme = config.theme.colorsHex;
in
{
  options.programs.swayosd = {
    enable = lib.mkEnableOption "SwayOSD volume/brightness overlay";
  };

  config = lib.mkIf cfg.enable {
    # SwayOSD config
    xdg.configFile."swayosd/config.toml".text = ''
      [server]
      show_percentage = true
      max_volume = 100
    '';

    # SwayOSD style
    xdg.configFile."swayosd/style.css".text = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
      }

      window#osd {
        background-color: alpha(#${theme.color0}, 0.9);
        border: 2px solid #${theme.accent};
        border-radius: 0;
        padding: 10px 20px;
      }

      progressbar {
        background-color: #${theme.color8};
        color: #${theme.accent};
        min-height: 8px;
      }

      image {
        color: #${theme.foreground};
      }
    '';
  };
}
