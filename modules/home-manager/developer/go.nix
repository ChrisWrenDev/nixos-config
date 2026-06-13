{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.developer.enable {
    home.packages = with pkgs; [
      gopls
      air
      templ
      goreleaser
      grpcurl
      golangci-lint
      gosimports
      gofumpt
      delve
    ];
  };
}
