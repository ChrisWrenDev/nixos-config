{pkgs, ...}: {
  programs = {
    go = {
      enable = true;
      goPath = "code/go";
    };
  };

  home.packages = with pkgs; [
    gcc
    zig

    gopls
    air
    templ

    python312
    python312Packages.pipx

    bun
    nodejs
    nodePackages.pnpm
    nodePackages.yarn

    typescript

    luarocks

    rustup
    rustlings
    lldb

    nixpkgs-fmt
    nix-output-monitor

    # nix
    nil # Language Server
    statix # Lints and suggestions
    deadnix # Find and remove unused
    alejandra # Code Formatter

    gnumake

    hexyl

    tokei
  ];
}
