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

  # Only the plain (non-uwsm) Hyprland session is offered to SDDM, and it is
  # the default. We deliberately run through the plain `hyprland.desktop`
  # entry (`start-hyprland` directly) instead of the `hyprland-uwsm` session:
  # uwsm's `dbus-launch` fails under SDDM ("Unable to autolaunch a
  # dbus-daemon..."), killing the session into a black screen with a stray
  # cursor.
  #
  # SDDM lists every *.desktop under share/wayland-sessions, and the bare
  # Hyprland package ships both `hyprland.desktop` and `hyprland-uwsm.desktop`.
  # `lib.mkForce` overrides `programs.hyprland`'s own
  # `sessionPackages = [ hyprland-package ]` (which includes hyprland-uwsm).
  services.displayManager.sessionPackages = lib.mkForce [
    (pkgs.runCommand "hyprland-session-only"
      {
        providedSessions = [ "hyprland" ];
      }
      ''
        mkdir -p $out/share/wayland-sessions
        ln -sf ${config.programs.hyprland.package}/share/wayland-sessions/hyprland.desktop $out/share/wayland-sessions/hyprland.desktop
      ''
    )
  ];

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "hyprland";
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
