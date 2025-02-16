 { ... }:

{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/wezterm
    ../../modules/home-manager/shell
    ../../modules/home-manager/zsh
    ../../modules/home-manager/starship
    ../../modules/home-manager/tmux

    ../../modules/home-manager/nvim

    ../../modules/home-manager/git
  ];

  programs.gpg.enable = true;
  
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  # home.packages = with pkgs; [];

  home.stateVersion = "24.11";
}
