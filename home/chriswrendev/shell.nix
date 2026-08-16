{
  config,
  lib,
  pkgs,
  ...
}:
let
  theme = config.theme.colorsHex;

  # Omarchy-inspired shell functions (kept in a standalone file for clarity)
  shellFunctions = builtins.readFile ./shell-functions.sh;

  zshInit = ''
    setopt AUTOCD
    setopt PROMPT_SUBST
    setopt MENU_COMPLETE
    setopt LIST_PACKED
    setopt AUTO_LIST
    setopt HIST_IGNORE_DUPS
    setopt HIST_FIND_NO_DUPS
    setopt COMPLETE_IN_WORD
    stty start undef
    stty stop undef
    setopt noflowcontrol

    # History
    HISTFILE=$HOME/.zhistory
    SAVEHIST=1000
    HISTSIZE=999
    setopt share_history
    setopt hist_expire_dups_first
    setopt hist_ignore_dups
    setopt hist_verify

    # Integrations
    eval "$(fzf --zsh)"
    eval "$(starship init zsh)"
  '';
in
{
  # Zsh as the interactive shell, with the Omarchy aliases/functions/env
  # layered on (see shell-functions.sh below).
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      c = "opencode";
      d = "docker";
      r = "rails";
      t = "tmux attach || tmux new -s Work";
      n = "nvim .";
      g = "git";
      gcm = "git commit -m";
      gcam = "git commit -a -m";
      gcad = "git commit -a --amend";
      ls = "eza -lh --group-directories-first --icons=auto";
      lsa = "ls -a";
      lt = "eza --tree --level=2 --long --icons --git";
      lta = "lt -a";
      decompress = "tar -xzf";
    };

    # Note: `builtins.readFile` must not be spliced into this literal, because
    # the function file contains `${...}` that the Nix string parser would
    # misinterpret. We therefore concatenate at the end of the let-binding.
    initContent = zshInit + shellFunctions;
  };

  # Starship prompt, themed to the active color scheme
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = "[░▒▓](${theme.color8})[ 󰊠 ](bg:${theme.accent} fg:${theme.background})[ ](bg:${theme.color4} fg:${theme.accent})$directory[](fg:${theme.color4} bg:${theme.color5})$git_branch$git_status[](fg:${theme.color5} bg:${theme.color6})$nodejs$rust$golang$lua$zig[](fg:${theme.color6} bg:${theme.color7})$time[ ](fg:${theme.color7})\n$character";

      directory = {
        style = "fg:${theme.foreground} bg:${theme.color4}";
        format = "[ $path ]($style)";
        read_only = " 󰌾";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "bg:${theme.color5}";
        format = "[[ $symbol $branch ](fg:${theme.color4} bg:${theme.color5})]($style)";
      };

      git_status = {
        style = "bg:${theme.color5}";
        format = "[[($all_status$ahead_behind )](fg:${theme.color4} bg:${theme.color5})]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:${theme.color6}";
        format = "[[ $symbol ($version) ](fg:${theme.color4} bg:${theme.color6})]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:${theme.color6}";
        format = "[[ $symbol ($version) ](fg:${theme.color4} bg:${theme.color6})]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:${theme.color6}";
        format = "[[ $symbol ($version) ](fg:${theme.color4} bg:${theme.color6})]($style)";
      };

      zig = {
        symbol = "";
        style = "bg:${theme.color6}";
        format = "[[ $symbol ($version) ](fg:${theme.color4} bg:${theme.color6})]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:${theme.color7}";
        format = "[[  $time ](fg:${theme.foreground} bg:${theme.color7})]($style)";
      };
    };
  };

  # Shell tools used by the aliases/functions above
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
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

  # Environment variables
  home.sessionVariables = {
    LANG = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
    PAGER = "less -FirSwX";
    BAT_THEME = "ansi";
    MANROFFOPT = "-c";
    FZF_DEFAULT_OPTS = "--color=fg:${theme.foreground},bg:${theme.background},hl:${theme.accent},fg+:${theme.foreground},bg+:${theme.color0},hl+:${theme.accent},info:${theme.color4},prompt:${theme.color6},pointer:${theme.color6},marker:${theme.color6},spinner:${theme.color6},header:${theme.color6}";
    FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
  };
}
