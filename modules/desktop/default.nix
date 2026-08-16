{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Hyprland session (NixOS provides the session entry point; Home Manager
  # owns the per-user Hyprland configuration).
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

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Firmware updates
  services.fwupd.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;

  # Virtual filesystem (MTP, SMB, NFS support for Nautilus)
  services.gvfs.enable = true;

  # Screen locking
  security.pam.services.hyprlock = { };

  # XDG portal for screen sharing, file dialogs
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Polkit for privilege escalation UI
  security.polkit.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts-color-emoji
    noto-fonts
    liberation_ttf
    font-awesome
  ];

  # Match Omarchy's fontconfig aliases: monospace = JetBrains Mono, and a
  # Liberation fallback for sans/serif.
  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" ];
    sansSerif = [ "Liberation Sans" ];
    serif = [ "Liberation Serif" ];
  };
}
