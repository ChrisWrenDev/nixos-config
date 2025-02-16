{pkgs, ...}: {
  programs = {
    # Navigation / Search
    zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
    ripgrep.enable = true;
    fzf.enable = true;
    fd.enable = true;

    # File Management / Utilities
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    bat.enable = true;

    btop = {
      enable = true;
      settings = {
        theme_background = false;
        update_ms = 1000;
        presets = "cpu:0:default mem:0:default net:0:default";
      };
    };
  };

  home.packages = with pkgs; [
    # File Management
    fd
    lsd
    zip
    unzip

    # System Monitoring
    duf
    btop
    htop
    gdu

    # Networking
    wget
    curl
    xh
    dig

    # Data Processing
    jq
    yq
    xsv

    tldr

    ffmpeg

    nitch
  ];
}
