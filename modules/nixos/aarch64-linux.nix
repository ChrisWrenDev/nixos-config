{
  config,
  pkgs,
  lib,
  currentSystemName,
  ...
}: {
  # Boot loader defaults for aarch64-linux VMs
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "0";

  # Be careful updating this.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config.permittedInsecurePackages = [
    "mupdf-1.17.0"
  ];

  # Virtualisation
  virtualisation.lxd.enable = true;

  # Input method
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-chinese-addons
    ];
  };

  # Fonts
  fonts.packages = [
    pkgs.fira-code
    pkgs.jetbrains-mono
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    cachix
    gnumake
    killall
    niv
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
  ] ++ lib.optionals (currentSystemName == "vm-aarch64") [
    gtkmm3
  ];

  # Default desktop environment (for specialisations)
  services.xserver = lib.mkIf (config.specialisation != {}) {
    enable = true;
    xkb.layout = "us";
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  # Flatpak and Snap
  services.flatpak.enable = true;
  services.snap.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # Disable firewall in VMs
  networking.firewall.enable = false;
}
