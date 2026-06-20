{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Hyprland session
  programs.hyprland.enable = true;

  # Login manager (SDDM in Wayland mode)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "gb";
      variant = "";
    };
  };

  console.keyMap = "uk";
  hardware.keyboard.qmk.enable = true;

  # Printing
  services.printing.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # WirePlumber - use software volume control for all ALSA devices
  # Prevents hardware mixer quirks (like muffled audio on Realtek codecs)
  environment.etc."wireplumber/wireplumber.conf.d/alsa-soft-mixer.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            device.name = "~alsa_card.*"
          }
        ]
        actions = {
          update-props = {
            api.alsa.soft-mixer = true
          }
        }
      }
    ]
  '';

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Firmware updates
  services.fwupd.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;

  # Virtual filesystem (MTP, SMB, NFS support for Nautilus)
  services.gvfs.enable = true;

  # Screen locking
  security.pam.services.hyprlock = {};

  # XDG portal for screen sharing, file dialogs
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
    config.common.default = "*";
  };

  # Polkit for privilege escalation UI
  security.polkit.enable = true;

  # Shell
  programs.firefox.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    noto-fonts-emoji
    noto-fonts-extra
    cascadia-code
    font-awesome
  ];

  # Common system packages
  environment.systemPackages = with pkgs; [
    inputs.voxtype.packages.${system}.vulkan
    chromium
    killall
    gnupg
    pinentry
    pinentry-curses

    # Hyprland ecosystem
    swaybg
    swaylock
    wl-clipboard
    grim
    slurp
    hyprpicker
    playerctl
    brightnessctl
    pamixer
    pavucontrol
    networkmanagerapplet
    blueman
    mako
    uwsm
    wtype
    jq

    # Desktop apps
    alacritty
    bitwarden
    bitwarden-cli
    obsidian
    signal-desktop
    typora
    kdePackages.kdenlive
    obs-studio
    evince
    gnome-calculator
    gnome-disk-utility
    pinta
    xournalpp
    libreoffice-fresh
    mpv
    imv

    # AI / Local LLM
    ollama

    # Qt theming
    qt6.qtwayland
    qt5.qtwayland
    libsForQt5.qtstyleplugin-kvantum

    # Shell completions
    bash-completion
  ];
}
