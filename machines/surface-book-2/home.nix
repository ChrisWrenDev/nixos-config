{
  pkgs,
  username,
  ...
}: {
  imports = [
    ../../modules/home-manager/desktop/awesome
    ../../modules/home-manager/desktop/hyprland
    ../../modules/home-manager/desktop/waybar
    ../../modules/home-manager/desktop/rofi

    ../../modules/home-manager/picom
    ../../modules/home-manager/floorp
    ../../modules/home-manager/firefox

    ../../modules/home-manager/alacritty
    ../../modules/home-manager/wezterm
    ../../modules/home-manager/ghostty
    
    ../../modules/home-manager/shell
    ../../modules/home-manager/starship
    ../../modules/home-manager/tmux

    ../../modules/home-manager/vs-code
    ../../modules/home-manager/helix
    ../../modules/home-manager/nvim

    ../../modules/home-manager/git
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };

  qt.enable = true;
  qt.platformTheme.name = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

  gtk = {
    enable = true;
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela-black";
    };
  };

  home.packages = with pkgs; [
    anydesk
    rawtherapee
    beekeeper-studio
    obs-studio
    flameshot
    libreoffice-qt
    copyq
    vlc
    tor-browser
  ];

  home.persistence."/persist/home/${username}" = {
    directories = [
      "Downloads"
      "Music"
      "Wallpapers"
      "Documents"
      "Videos"
      "Projects"
      ".mozilla"
      ".ssh"
      ".config/copyq"
      ".local/share/nvim"
      ".local/share/zoxide"
      ".local/share/Smart\ Code\ ltd"
      ".local/state/lazygit"
    ];
    files = [
      ".zsh_history"
    ];
    allowOther = true;
  };

  home.stateVersion = "24.11";
}
