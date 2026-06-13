{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.tmux-custom;
  theme = config.theme.colorsHex;
in
{
  options.programs.tmux-custom = {
    enable = lib.mkEnableOption "Tmux configuration with custom settings";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "t" (builtins.readFile ./session-manager))
    ];

    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      historyLimit = 50000;
      keyMode = "vi";
      mouse = true;
      prefix = "C-Space";

      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        resurrect
        continuum
        {
          plugin = tokyo-night-tmux;
          extraConfig = ''
            set -g @tokyo-night-theme "night"
          '';
        }
      ];

      extraConfig = ''
        # Prefix
        set -g prefix C-Space
        set -g prefix2 C-b
        bind C-Space send-prefix

        # Vi mode for copy
        setw -g mode-keys vi
        bind -T copy-mode-vi v send -X begin-selection
        bind -T copy-mode-vi y send -X copy-selection-and-cancel

        # Pane controls
        bind h split-window -v -c "#{pane_current_path}"
        bind v split-window -h -c "#{pane_current_path}"
        bind x kill-pane

        bind -n C-M-Left select-pane -L
        bind -n C-M-Right select-pane -R
        bind -n C-M-Up select-pane -U
        bind -n C-M-Down select-pane -D

        bind -n C-M-S-Left resize-pane -L 5
        bind -n C-M-S-Down resize-pane -D 5
        bind -n C-M-S-Up resize-pane -U 5
        bind -n C-M-S-Right resize-pane -R 5

        # Window navigation
        bind r command-prompt -I "#W" "rename-window -- '%%'"
        bind c new-window -c "#{pane_current_path}"
        bind k kill-window

        bind -n M-1 select-window -t 1
        bind -n M-2 select-window -t 2
        bind -n M-3 select-window -t 3
        bind -n M-4 select-window -t 4
        bind -n M-5 select-window -t 5
        bind -n M-6 select-window -t 6
        bind -n M-7 select-window -t 7
        bind -n M-8 select-window -t 8
        bind -n M-9 select-window -t 9

        bind -n M-Left select-window -t -1
        bind -n M-Right select-window -t +1
        bind -n M-S-Left swap-window -t -1 \; select-window -t -1
        bind -n M-S-Right swap-window -t +1 \; select-window -t +1

        # Session controls
        bind R command-prompt -I "#S" "rename-session -- '%%'"
        bind C new-session -c "#{pane_current_path}"
        bind K kill-session
        bind P switch-client -p
        bind N switch-client -n

        bind -n M-Up switch-client -p
        bind -n M-Down switch-client -n

        # Smart tmux session manager (t-smart-tmux-session-manager)
        bind T run-shell "t"

        # General
        set -ag terminal-overrides ",*:RGB"
        set -g base-index 1
        setw -g pane-base-index 1
        set -g renumber-windows on
        set -g escape-time 0
        set -g focus-events on
        set -g set-clipboard on
        set -g allow-passthrough on
        setw -g aggressive-resize on
        set -g detach-on-destroy off
        set -g extended-keys on
        set -g extended-keys-format csi-u
        set -sg escape-time 10

        # Status bar
        set -g status-position top
        set -g status-interval 5
        set -g status-left-length 30
        set -g status-right-length 50
        set -g window-status-separator ""
        set -gw automatic-rename on
        set -gw automatic-rename-format '#{b:pane_current_path}'

        # Theme (uses theme colors)
        set -g status-style "bg=default,fg=default"
        set -g status-left "#[fg=${theme.background},${theme.accent},bold] #S #[bg=default] "
        set -g status-right "#[fg=${theme.accent}]#{?pane_in_mode,COPY ,}#{?client_prefix,PREFIX ,}#{?window_zoomed_flag,ZOOM ,}#[fg=${theme.color8}]#h "
        set -g window-status-format "#[fg=${theme.color8}] #I:#W "
        set -g window-status-current-format "#[fg=${theme.accent},bold] #I:#W "
        set -g pane-border-style "fg=${theme.color8}"
        set -g pane-active-border-style "fg=${theme.accent}"
        set -g message-style "bg=default,fg=${theme.accent}"
        set -g message-command-style "bg=default,fg=${theme.accent}"
        set -g mode-style "bg=${theme.accent},fg=${theme.background}"
        setw -g clock-mode-colour ${theme.accent}
      '';
    };
  };
}
