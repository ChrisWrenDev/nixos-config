{pkgs, ...}: {
  xdg.configFile = {
    "ghostty/config".text = builtins.readFile ./ghostty.linux;
  };

  home.packages = with pkgs; [
    ghostty
  ];
}
