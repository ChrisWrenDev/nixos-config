{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.developer.enable {
    home.packages = with pkgs; [
      python312
      python312Packages.pipx
      python312Packages.debugpy
      poetry
      pyright
      ruff
      isort
    ];
  };
}
