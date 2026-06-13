{pkgs, ...}: {
  # Nix settings (shared across all Linux machines)
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      keep-outputs = true;
      keep-derivations = true;
    };
  };

  # SSH (shared across all Linux machines)
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

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;
  users.users.chriswrendev = {
    isNormalUser = true;
    description = "chriswrendev";
    home = "/home/chriswrendev";
    extraGroups = ["networking" "wheel" "docker" "lxd"];
    shell = pkgs.zsh;
    hashedPassword = "$6$epwox8wAJ/.OETm7$nB0m6xAFy7ebklXNXya1N2bc4xxhfB3YRdc2o/JlHyd0qVGWJMyQ7Y/wexY21GYfGxh6WPMO4OoiKrPcrI1jp/";
    openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIObVHipQ0zzDlLZuuim8HSSyBhSw9IEMAyWg3Rt74vmb chriswrendeveloper@gmail.com"
    ];
  };
}
