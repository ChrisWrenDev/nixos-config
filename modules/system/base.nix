{
  config,
  lib,
  pkgs,
  user,
  ...
}:
{
  # Allow unfree packages (google-chrome, etc.)
  nixpkgs.config.allowUnfree = true;

  # Nix settings
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      keep-outputs = true;
      keep-derivations = true;
    };
  };

  # SSH
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";

  # Security
  security.sudo.wheelNeedsPassword = false;

  # Shell
  programs.zsh.enable = true;

  # Docker
  virtualisation.docker.enable = true;

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Keep passwords out of git. With the default `mutableUsers = true`, NixOS
  # will not touch the existing `/etc/shadow` entry, so the password set with
  # `passwd` during installation keeps working. `sudo` is passwordless for the
  # wheel group (line above), so on a truly fresh machine you can still run:
  #   sudo passwd chriswrendev
  users.defaultUserShell = pkgs.zsh;
  users.users.${user} = {
    isNormalUser = true;
    description = "chriswrendev";
    home = "/home/${user}";
    extraGroups = [
      "networking"
      "wheel"
      "docker"
      "lxd"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObVHipQ0zzDlLZuuim8HSSyBhSw9IEMAyWg3Rt74vmb chriswrendeveloper@gmail.com"
    ];
  };
}
