{pkgs, ...}:
{
  programs.go = {
    enable = true;
    goPath = "code/go";
  };

  home.packages = with pkgs; [
    gopls
  ];
}
