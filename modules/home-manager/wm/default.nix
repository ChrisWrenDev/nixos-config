{pkgs, ...}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  xdg.enable = true;

  xdg.configFile =
    {
      "i3/config".text = builtins.readFile ./i3;
      "rofi/config.rasi".text = builtins.readFile ./rofi;
    }
    // (
      if isDarwin
      then {
        # Rectangle.app. This has to be imported manually using the app.
        "rectangle/RectangleConfig.json".text = builtins.readFile ./RectangleConfig.json;
      }
      else {}
    );

  programs.i3status = {
    enable = isLinux;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  home.packages = with pkgs; [
    rofi
  ];
}
