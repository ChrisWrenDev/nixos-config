{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hyprland;
  mod = "SUPER";
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        # ── Application launching ──
        "${mod}, Return, exec, uwsm-app -- ghostty"
        "${mod} SHIFT, Return, exec, uwsm-app -- ghostty -e tmux new-session -s Work"
        "${mod} SHIFT, B, exec, uwsm-app -- google-chrome"
        "${mod} SHIFT, N, exec, uwsm-app -- ghostty -e nvim ."
        "${mod} SHIFT, F, exec, uwsm-app -- nautilus --new-window"
        "${mod} SHIFT, D, exec, uwsm-app -- ghostty -e lazydocker"
        "${mod} SHIFT, G, exec, uwsm-app -- signal-desktop"
        "${mod} SHIFT, O, exec, uwsm-app -- obsidian"

        # ── Window management ──
        "${mod}, W, killactive,"
        "${mod}, T, togglefloating,"
        "${mod}, F, fullscreen,"
        "${mod} CTRL, F, fullscreenstate, 0 2"
        "${mod} ALT, F, fullscreen, maximize"
        "${mod}, J, togglesplit,"
        "${mod}, P, pseudo,"
        "${mod}, O, pin,"
        "${mod}, L, layoutmsg, togglesplit"
        "${mod}, G, togglegroup,"
        "${mod} ALT, G, movewindoworgroup,"
        "${mod} ALT, TAB, changegroupactive,"
        "${mod} ALT SHIFT, TAB, changegroupactive, -1"
        "${mod}, S, togglespecialworkspace, scratchpad"
        "${mod} SHIFT, S, movetoworkspace, special:scratchpad"

        # ── Focus ──
        "${mod}, H, movefocus, l"
        "${mod}, Left, movefocus, l"
        "${mod}, L, movefocus, r"
        "${mod}, Right, movefocus, r"
        "${mod}, K, movefocus, u"
        "${mod}, Up, movefocus, u"
        "${mod}, J, movefocus, d"
        "${mod}, Down, movefocus, d"

        # ── Swap ──
        "${mod} SHIFT, Left, swapwindow, l"
        "${mod} SHIFT, Right, swapwindow, r"
        "${mod} SHIFT, Up, swapwindow, u"
        "${mod} SHIFT, Down, swapwindow, d"

        # ── Workspaces (1-10) ──
        "${mod}, 1, workspace, 1"
        "${mod}, 2, workspace, 2"
        "${mod}, 3, workspace, 3"
        "${mod}, 4, workspace, 4"
        "${mod}, 5, workspace, 5"
        "${mod}, 6, workspace, 6"
        "${mod}, 7, workspace, 7"
        "${mod}, 8, workspace, 8"
        "${mod}, 9, workspace, 9"
        "${mod}, 0, workspace, 10"

        # ── Move to workspace ──
        "${mod} SHIFT, 1, movetoworkspace, 1"
        "${mod} SHIFT, 2, movetoworkspace, 2"
        "${mod} SHIFT, 3, movetoworkspace, 3"
        "${mod} SHIFT, 4, movetoworkspace, 4"
        "${mod} SHIFT, 5, movetoworkspace, 5"
        "${mod} SHIFT, 6, movetoworkspace, 6"
        "${mod} SHIFT, 7, movetoworkspace, 7"
        "${mod} SHIFT, 8, movetoworkspace, 8"
        "${mod} SHIFT, 9, movetoworkspace, 9"
        "${mod} SHIFT, 0, movetoworkspace, 10"

        # ── Workspace navigation ──
        "${mod}, Tab, workspace, e+1"
        "${mod} SHIFT, Tab, workspace, e-1"
        "${mod} CTRL, Tab, workspace, previous"

        # ── Move workspace to monitor ──
        "${mod} SHIFT ALT, Left, moveworkspacetomonitor, l"
        "${mod} SHIFT ALT, Right, moveworkspacetomonitor, r"
        "${mod} SHIFT ALT, Up, moveworkspacetomonitor, u"
        "${mod} SHIFT ALT, Down, moveworkspacetomonitor, d"

        # ── Group management ──
        "${mod} ALT, Left, movewindow, l"
        "${mod} ALT, Right, movewindow, r"
        "${mod} ALT, Up, movewindow, u"
        "${mod} ALT, Down, movewindow, d"
        "${mod} CTRL, Left, movecurrentworkspacesplit, l"
        "${mod} CTRL, Right, movecurrentworkspacesplit, r"

        # ── Screenshots ──
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "${mod}, Print, exec, grim - | wl-copy"

        # ── Clipboard ──
        "${mod}, C, sendshortcut, CTRL, Insert,"
        "${mod}, V, sendshortcut, SHIFT, Insert,"
        "${mod}, X, sendshortcut, CTRL, X,"
        "${mod} CTRL, V, exec, walker -m clipboard"

        # ── App launcher & utilities ──
        "${mod}, Space, exec, walker"
        "${mod}, Escape, exec, walker"
        "${mod} ALT, Space, exec, walker"
        "${mod} CTRL, E, exec, walker -m symbols"

        # ── System ──
        "${mod} CTRL, L, exec, hyprlock"
        "${mod} SHIFT, Space, exec, pkill waybar || waybar"
        "${mod}, Backspace, exec, hyprctl keyword decoration:active_opacity 0.85"
        "${mod} SHIFT, Backspace, exec, hyprctl keyword general:gaps_in 0 && hyprctl keyword general:gaps_out 0"
        "${mod} SHIFT, C, exec, hyprpicker -a"

        # ── Notifications ──
        "${mod}, Comma, exec, makoctl dismiss"
        "${mod} SHIFT, Comma, exec, makoctl dismiss --all"
        "${mod} ALT, Comma, exec, makoctl invoke"
        "${mod} SHIFT ALT, Comma, exec, makoctl restore"

        # ── Toggles ──
        "${mod} CTRL, I, exec, hypridle"
        "${mod} CTRL, N, exec, hyprsunset -t 4000"
        "${mod} CTRL, T, exec, btop"
        "${mod} CTRL, X, exec, voxtype record toggle"

        # ── Media (with SwayOSD feedback) ──
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        "SHIFT, XF86MonBrightnessUp, exec, brightnessctl set 100%"
        "SHIFT, XF86MonBrightnessDown, exec, brightnessctl set 1%"
        "ALT, XF86AudioRaiseVolume, exec, swayosd-client --output-volume +1"
        "ALT, XF86AudioLowerVolume, exec, swayosd-client --output-volume -1"
        "ALT, XF86MonBrightnessUp, exec, brightnessctl set 1%+"
        "ALT, XF86MonBrightnessDown, exec, brightnessctl set 1%-"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindm = [
        # ── Mouse bindings ──
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
        "${mod}, mouse_down, workspace, e+1"
        "${mod}, mouse_up, workspace, e-1"
      ];

      # Window rules are defined in windows.nix
    };
  };
}
