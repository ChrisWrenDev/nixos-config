{pkgs, ...}: 
{
  home.file = {
    ".config/awesome" = {
      recursive = true;
      source = "${pkgs.awesome-wm-config}";
    };
  };
}
