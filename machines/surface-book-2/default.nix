{ config, pkgs, currentSystemUser, ... }:

{
  imports =
    [
      ./hardware.nix
      ../shared
      ../../modules/nixos/desktop
      ../../modules/nixos/desktop/awesome
      ../../modules/nixos/desktop/hyprland
      ../../modules/nixos/virtualisation
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "surface-book-2"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services = {
    flatpak.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    xrdp = {
      enable = true;
      defaultWindowManager = true;
      audio.enable = true;
    };

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver = {
      enable = true;
      xkb = {
        layout = "gb";
        variant = "";
      };
    };
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts-fira-code
    nerd-fonts-jetbrains-mono
  ];

  programs = {
    fuse.userAllowOther = true;
    xfconf.enable = true;
    file-roller.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thuar-archive-plugin thunar-volman];
    };
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
  };

  nixpkgs.overlays = import ../../lib/overlays.nix;
  
    # overlays = [
    # outputs.overlays.additions
    # outputs.overlays.modifications
    # outputs.overlays.stable-packages
    # outputs.overlays.nur
    # outputs.overlays.nix-vscode-extensions
    # ]; 

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.joypixels.acceptLicence = true;

  
  nix.package = pkgs.lix;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    trusted-users = ["${currentSystemUser}"];
    warn-dirty = true;   
    substituters = [
      "https://cache.nixos.org?priority=10"
      "https://anyrun.cachix.org"
      "https://helix.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://yazi.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
    ];
    security.sudo.wheelNeedsPassword = false;
    programs = {
      zsh.enable = true;
      nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 5d --keep 5";
        flake = "home/${currentSystemUser}/nixos-config";
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "24.11"; # Did you read the comment?

}
