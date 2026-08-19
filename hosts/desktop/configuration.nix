{config, ...}: {
  imports = [
    # System related configuration
    ../../nixos/audio.nix
    ../../nixos/bluetooth.nix
    ../../nixos/fonts.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/systemd-boot.nix
    ../../nixos/tuigreet.nix
    ../../nixos/users.nix
    ../../nixos/utils.nix
    ../../nixos/hyprland.nix
    ../../nixos/steam.nix
    ../../nixos/ollama.nix
    ../../home/programs/gui/helium/system.nix

    ./persistence.nix
    ./hardware-configuration.nix
    ./variables.nix
  ];

  home-manager.users."${config.var.username}" = import ./home.nix;

  users.users.${config.var.username}.hashedPasswordFile = config.sops.secrets.hashed-password.path;;

  # Don't touch this
  system.stateVersion = "26.05";
}
