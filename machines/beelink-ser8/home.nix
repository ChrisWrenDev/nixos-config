{
  pkgs,
  ...
}: {
  imports = [
    ../shared/home.nix
    ../../modules/home-manager/nvim
    ../../modules/home-manager/developer
    ../../modules/home-manager/zsh
    ../../modules/home-manager/starship
    ../../modules/home-manager/ghostty
    ../../modules/home-manager/wezterm
    ../../modules/home-manager/shell
#    ../../modules/home-manager/hyprland
#    ../../modules/home-manager/waybar
#    ../../modules/home-manager/mako
#    ../../modules/home-manager/hyprlock
#    ../../modules/home-manager/hypridle
#    ../../modules/home-manager/walker
#    ../../modules/home-manager/swayosd
    ../../modules/home-manager/voxtype
    ../../modules/home-manager/git
    ../../modules/home-manager/tmux-custom
    ../../modules/home-manager/btop
    ../../modules/home-manager/fastfetch
    ../../modules/home-manager/opencode
    ../../modules/home-manager/vs-code
  ];

  programs.nvim-custom.enable = true;
  developer.enable = true;
  programs.zsh-custom.enable = true;
  programs.wezterm-custom.enable = true;
  programs.ghostty-custom.enable = true;
  shell.enable = true;
#  hyprland.enable = true;
#  waybar.enable = true;
#  services.mako-custom.enable = true;
#  services.hypridle-custom.enable = true;
#  programs.swayosd.enable = true;
#  programs.walker.enable = true;
  programs.voxtype-custom.enable = true;
  programs.git-custom.enable = true;
  programs.btop-custom.enable = true;
  programs.fastfetch-custom.enable = true;
  programs.opencode-custom.enable = true;
  programs.vscode-custom.enable = true;

  theme.active = "tokyo-night";
}
