{pkgs, ...}: {
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASURMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  users.mutableUsers = true;
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

  # programs.zsh.enable = true;

  # nixpkgs.overlays = import ../../lib/overlays.nix;
}
