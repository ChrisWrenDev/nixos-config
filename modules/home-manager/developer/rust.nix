{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.developer.enable {
    home.packages = with pkgs; [
      rustup
      rust-analyzer
      cargo
      rustc
      rustlings
      cargo-nextest
      cargo-watch
      bacon
      cargo-generate
      cargo-deny
      lldb
      sccache
    ];
  };
}
