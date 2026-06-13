{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mako-custom;
  theme = config.theme.colorsHex;
in
{
  options.services.mako-custom = {
    enable = lib.mkEnableOption "Mako notification daemon with theme";
  };

  config = lib.mkIf cfg.enable {
    services.mako.enable = true;

    # Mako config file
    xdg.configFile."mako/config".text = ''
      anchor=top-right
      width=420
      height=150
      margin=20
      padding=10,15
      border-size=2
      border-color=${theme.accent}
      max-icon-size=32

      border-radius=0
      font=JetBrainsMono Nerd Font 10
      background-color=${theme.background}
      text-color=${theme.foreground}
      default-color=${theme.foreground}

      default-timeout=5000
      ignore-timeout=1
      actions=true
      clickable=true
      close=true
      close-on-click=true
      max-visible=5
      layer=overlay

      group-by=app-name,summary,body

      [app-name=Spotify]
      invisible=1

      [urgency=critical]
      default-timeout=0
    '';
  };
}
