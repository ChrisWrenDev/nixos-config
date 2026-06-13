{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.zsh-custom;
  theme = config.theme.colorsHex;
in
{
  options.programs.zsh-custom = {
    enable = lib.mkEnableOption "Full zsh configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      shellAliases = {
        x = "exit";
        k = "kubectl";
        tf = "terraform";
      };

      initExtra = ''
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

        # Plugins (history-substring-search before autocomplete to avoid binding conflicts)
        source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
        source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.zsh

        # Integrations
        eval "$(fzf --zsh)"
        eval "$(starship init zsh)"
      '';
    };

    home.sessionVariables = {
      FZF_DEFAULT_OPTS = "--color=fg:${theme.foreground},bg:${theme.background},hl:${theme.accent},fg+:${theme.foreground},bg+:${theme.color0},hl+:${theme.accent},info:${theme.color4},prompt:${theme.color6},pointer:${theme.color6},marker:${theme.color6},spinner:${theme.color6},header:${theme.color6}";
      FZF_DEFAULT_COMMAND = "fd --hidden --strip-cwd-prefix --exclude .git";
      RUSTC_WRAPPER = "sccache";
      RUSTUP_HOME = "$HOME/rust-cache/rustup";
      CARGO_HOME = "$HOME/rust-cache/cargo";
      CARGO_TARGET_DIR = "$HOME/rust-cache/target";
      SCCACHE_DIR = "$HOME/rust-cache/sccache";
      SCCACHE_CACHE_SIZE = "50G";
    };
  };
}
