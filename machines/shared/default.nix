{pkgs, ...}:
{
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
    extraGroups = [ "networking" "wheel" "docker" "lxd" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # nixpkgs.overlays = import ../../lib/overlays.nix;
}
