{ ... }:
{
  imports = [
    ../shared/home.nix
    ../../modules/home-manager/nvim
    ../../modules/home-manager/developer
    ../../modules/home-manager/wezterm
    ../../modules/home-manager/opencode
  ];

  programs.nvim-custom.enable = true;
  developer.enable = true;
  programs.wezterm-custom.enable = true;
  programs.opencode-custom.enable = true;
}
