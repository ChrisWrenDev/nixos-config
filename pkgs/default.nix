{pkgs, ...}: {
  awesome-wm-config = pkgs.callPackage ./awesome {};
  nvim-config = pkgs.callPackage ./nvim {};
  firefox-mod-blur = pkgs.callPackage ./firefox-mod-blur {};
  parallels-tools = pkgs.callPackage ./parallels-tools {};
}
