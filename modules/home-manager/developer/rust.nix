{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.developer.enable {
    home.packages = with pkgs; [
      rustup
      rustlings
      cargo-nextest
      cargo-watch
      bacon
      cargo-generate
      cargo-deny
      gdb
      sccache
    ];
  };
}
