{pkgs, ...}:
{
  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;
  users.users.chriswrendev = {
    isNormalUser = true;
    home = "/home/chriswrendev";
    extraGroups = [ "docker" "lxd" "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "";
    openssh.authorizedKeys.keys = [
      ""
    ];
  };

  nixpkgs.overlays = import ../../lib/overlays.nix;
}
