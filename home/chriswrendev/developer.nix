{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Developer environment: language toolchains and productivity tools that are
  # genuinely part of the Omarchy default experience.
  home.packages = with pkgs; [
    # Version control
    gh
    lazygit
    lazydocker

    # Shell utilities
    zip
    unzip
    duf
    gdu
    dust
    xh
    dig
    yq
    tldr
    just
    inxi
    ffmpeg
    nitch

    # Build tools
    gcc
    gnumake
    cmake
    bun
    pnpm
    typescript
    luarocks

    # Formatters / linters
    stylua
    shfmt
    hadolint
    shellcheck
    yamllint

    # Languages
    rustup
    gopls
    python312
    poetry
    pyright
    ruff

    # LSP servers (language-agnostic)
    lua-language-server
    typescript-language-server
    yaml-language-server
    terraform-ls
    helm-ls
    bash-language-server
    marksman

    # Protobuf
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc

    # K8s / infra
    kubectl
    k9s
    terraform
    qmk

    # Nix tooling
    nixpkgs-fmt
    alejandra

    # Base
    curl
    wget
    sqlite
  ];

  programs.go = {
    enable = true;
    env.GOPATH = "$HOME/code/go";
  };
}
