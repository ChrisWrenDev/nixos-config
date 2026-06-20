{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.shell;
  isLinux = pkgs.stdenv.isLinux;
in
{
  options.shell = {
    enable = lib.mkEnableOption "Shell aliases, functions, and environment variables";
  };

  config = lib.mkIf cfg.enable {
    #-------------------------------------------------------------------
    # Aliases
    #-------------------------------------------------------------------
    home.shellAliases = {
      # File listing
      ls = "eza -lh --group-directories-first --icons=auto";
      lsa = "ls -a";
      lt = "eza --tree --level=2 --long --icons --git";
      lta = "lt -a";

      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Editor
      n = "nvim .";

      # Tools
      c = "opencode";
      d = "docker";
      r = "rails";
      t = "tmux attach || tmux new -s Work";

      # Git
      g = "git";
      gcm = "git commit -m";
      gcam = "git commit -a -m";
      gcad = "git commit -a --amend";

      # Compression
      decompress = "tar -xzf";
    };

    #-------------------------------------------------------------------
    # Shell functions
    #-------------------------------------------------------------------
    programs.zsh.initContent = builtins.readFile ./shell-functions.sh;

    #-------------------------------------------------------------------
    # Environment variables
    #-------------------------------------------------------------------
    home.sessionVariables = {
      SUDO_EDITOR = "$EDITOR";
      BAT_THEME = "ansi";
      MANROFFOPT = "-c";
    };

    #-------------------------------------------------------------------
    # Programs (shell tools that complement the developer module)
    #-------------------------------------------------------------------

    programs.eza = lib.mkIf isLinux {
      enable = true;
      enableZshIntegration = true;
    };

    programs.bat = {
      enable = true;
      config.theme = "ansi";
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };

    programs.ripgrep.enable = true;
    programs.fd.enable = true;
  };
}
