{...}:
{
    programs.zsh = {
      enable = true;
      shellAliases = {
        ls = "lsd";
      };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      initExtra = ''
        nitch
        export WINIT_X11_SCALE_FACTOR=1
        bindkey "^A" vi-beginning-of-line
        bindkey "^E" vi-end-of-line
        PATH=$PATH:~/.cargo/bin:~/.local/bin
      '';
    };
  }
