{...}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      theme = "tokyonight_night";
      font-size = 14;
    };
  };
}
