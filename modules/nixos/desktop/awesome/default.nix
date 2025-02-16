{
  lib,
  pkgs,
  ...
}: {
  services = {
    displayManager = {
      defaultSession = "none+awesome";
      sddm = {
        package = pkgs.libsForQt5.sddm;
        extraPackages = with pkgs; [libsForQt5.qt5.qtgraphicaleffects];
        enable = true;
        theme = "sugar-dark";
      };
    };

    xserver = {
      enable = true;
      windowManager.awesome = {
        enable = true;
        luaModules = lib.attrValues {
          inherit
            (pkgs.luajitPackages)
            lgi
            ldbus
            luadbi-mysql
            luaposix
            dkjson
            ;
        };
      };
    };

    acpid.enable = true;
    picom.enable = true;
    upower.enable = true;
    blueman.enable = true;
  };

  programs.dconf.enable = true;

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    XCURSOR_SIZE = "64";
  };

  environment.systemPackages = with pkgs; [
    luajit
    acpi
    linuxKernel.packages.linux_zen.acpi_call
    lxappearance
    inotify-tools
    polkit_gnome
    xdotool
    xclip
    xorg.xbacklight
    gpick
    alsa-utils
    pavucontrol
    brightnessctl
    libnotify
    feh
    maim
    mpdris2
    python311Packages.mutagen
    xdg-utils
    playerctl
    pulsemixer
    procps
    sct
    slop
    sddm-sugar-dark
  ];
}
