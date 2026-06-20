{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.developer.enable {
    home.packages = with pkgs; [
      # Version control
      gh
      lazygit
      lazydocker

      # Editor
      neovide

      # LSP servers (language-agnostic)
      lua-language-server
      typescript-language-server
      dockerfile-language-server-nodejs
      yaml-language-server
      terraform-ls
      helm-ls
      tailwindcss-language-server
      bash-language-server
      sqls
      svelte-language-server
      vue-language-server
      marksman

      # Shell utilities
      lsd
      zip
      unzip
      duf
      gdu
      dust
      xh
      dig
      yq
      xsv
      tldr
      just
      inxi
      ffmpeg
      nitch

      # Formatters
      stylua
      prettierd
      shfmt
      sql-formatter
      buf

      # Linters
      yamllint
      hadolint
      shellcheck
      tflint
      checkmake
      eslint

      # Languages
      gcc
      bun
      nodePackages.pnpm
      nodePackages.yarn
      typescript
      luarocks

      # Build
      gnumake
      hexyl
      tokei
      cmake

      # Utilities
      curl
      wget
      awscli2
      sqlite
      goose
      qmk
      yt-dlp
      terraform
      kubectl
      k9s
      pixi

      # Protobuf
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
    ];
  };
}
