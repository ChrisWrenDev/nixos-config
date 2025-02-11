/* This contains various packages we want to overlay. Note that the
 * other ".nix" files in this directory are automatically loaded.
 */
final: prev: {
  awesome-wm-config = final.callPackage ../pkgs/awesome {};
  nvim-config = final.callPackage ../pkgs/nvim {};
  # firefox-mod-blur = final.callPackage ../pkgs/firefox-mod-blur {};
}
