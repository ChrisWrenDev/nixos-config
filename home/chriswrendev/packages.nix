{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Core desktop & CLI packages. System-level services (PipeWire, Wayland,
  # Bluetooth, portals) are handled by NixOS modules; user-facing apps live here.
  #
  # Note: git/tmux/curl/wget and dev tooling are declared in
  # `home/chriswrendev/developer.nix` to avoid duplication.
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

    # Hyprland ecosystem
    grim
    slurp
    hyprpicker
    swaybg
    wl-clipboard
    wlogout
    hyprsunset

    # System / media control
    brightnessctl
    playerctl
    pamixer
    pavucontrol
    networkmanagerapplet
    blueman

    # Desktop apps (Omarchy default applications)
    chromium
    nautilus
    evince
    imv
    mpv
    gnome-calculator
    gnome-disk-utility
    obsidian
    signal-desktop
    gimp
  ];

  # Cursor theme (Bibata provides both X11 and Hyprland cursor variants).
  # Hyprland's `XCURSOR_SIZE`/`HYPRCURSOR_SIZE=24` match this size.
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    x11.enable = true;
    hyprcursor.enable = true;
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
