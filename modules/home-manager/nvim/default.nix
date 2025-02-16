{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    extraPackages = with pkgs; [ gcc clang ];
  };

  home.file = {
    ".config/nvim" = {
      recursive = true;
      source = "${pkgs.nvim-config}";
    };
  };

  home.packages = with pkgs; [
    neovide
  ];
}
