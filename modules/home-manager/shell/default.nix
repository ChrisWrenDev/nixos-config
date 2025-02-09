{pkgs, ...}: {
  programs = {
    bat.enable = true;
    lazygit.enable = true;
    zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
    ripgrep.enable = true;
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        update_ms = 1000;
        presets = "cpu:0:default mem:0:default net:0:default";
      };
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };
    go.enable = true;
    fzf.enable = true;
    # zellij.enable = true;
  };

  home.packages = with pkgs; [
    fd
    tldr
    duf
    service-wrapper
    lsd
    nitch
    ranger
    wget
    portal
    bore-cli
    zip
    unzip
    pciutils
    gnumake
    nvtopPackages.full
    jq
    atac
    termshark
    solc
    dig

    python312
    python312Packages.pipx

    bun
    nodejs
    nodePackages.pnpm
    nodePackages.yarn

    rustup

    nixpkgs-fmt
    nix-output-monitor

    hunspell
    hunspellDicts.en_GB

    air
    templ
    ffmpeg
  ];
}
