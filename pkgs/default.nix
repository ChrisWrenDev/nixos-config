{pkgs, ...}: {
  awesome-wm-config = pkgs.callPackage ./awesome {};
  nvim-config = pkgs.callPackage ./nvim {};
  parallels-tools = pkgs.callPackage ./parallels-tools {};
}
