{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Core packages. Most desktop/CLI software lives here (Home Manager owns the
  # user experience); system-level services are handled by NixOS modules.
  home.packages = with pkgs; [
    # Shell / CLI conveniences (Omarchy default set)
    bat
    eza
    fd
    fzf
    ripgrep
    jq
    tree
    htop
    btop
    bottom
    fastfetch
    watch
    nodejs
    zoxide

    # Core CLI tools
    curl
    wget
    git
    tmux

    # Hyprland ecosystem
    grim
    slurp
    hyprpicker
    swaybg
    wl-clipboard
    cliphist
    wlogout
    hyprsunset

    # System / media control
    brightnessctl
    playerctl
    pamixer
    pavucontrol
    networkmanagerapplet
    blueman

    # Audio
    pipewire
    wireplumber

    # Desktop apps (Omarchy default applications)
    chromium
    nautilus
    evince
    imv
    mpv
    gnome-calculator
    gnome-disk-utility
    # Editors
    obsidian
    signal-desktop
    # Image editing
    gimp
  ];

  # Cursor: keep it from being tiny on HiDPI displays
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };

  # Default applications via XDG
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = [ "chromium.desktop" ];
      "x-scheme-handler/https" = [ "chromium.desktop" ];
      "text/html" = [ "chromium.desktop" ];
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "image/png" = [ "imv.desktop" ];
      "image/jpeg" = [ "imv.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "video/*" = [ "mpv.desktop" ];
      "audio/*" = [ "mpv.desktop" ];
      "application/json" = [ "nvim.desktop" ];
      "text/x-shellscript" = [ "nvim.desktop" ];
      "text/plain" = [ "nvim.desktop" ];
    };
  };
}
