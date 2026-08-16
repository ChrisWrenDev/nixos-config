{
  config,
  lib,
  pkgs,
  ...
}:
let
  theme = config.theme.colorsHex;
  mod = "SUPER";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      # ----------------------------------------------------------------------
      # Environment
      # ----------------------------------------------------------------------
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_QPA_PLATFORMTHEME,gtk3"
        "MOZ_ENABLE_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "OZONE_PLATFORM,wayland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XCOMPOSEFILE,~/.XCompose"
      ];

      # ----------------------------------------------------------------------
      # General
      # ----------------------------------------------------------------------
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(${theme.accent}) rgb(${theme.color4}) 45deg";
        "col.inactive_border" = "rgb(${theme.color8})";
        layout = "dwindle";
        allow_tearing = false;
        resize_on_border = false;
      };

      # ----------------------------------------------------------------------
      # Decoration
      # ----------------------------------------------------------------------
      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          size = 2;
          passes = 2;
          special = true;
          brightness = 0.60;
          contrast = 0.75;
        };
        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      # ----------------------------------------------------------------------
      # Animation curves
      # ----------------------------------------------------------------------
      bezier = [
        "easeOutQuint, 0.23, 1, 0.32, 1"
        "easeInOutCubic, 0.65, 0.05, 0.36, 1"
        "linear, 0, 0, 1, 1"
        "almostLinear, 0.5, 0.5, 0.75, 1.0"
        "quick, 0.15, 0, 0.1, 1"
      ];

      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 3.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 0"
        "specialWorkspace, 1, 3, easeOutQuint, slidevert"
      ];

      # ----------------------------------------------------------------------
      # Layouts
      # ----------------------------------------------------------------------
      dwindle = {
        preserve_split = true;
        force_split = 2;
      };

      master = {
        new_status = "master";
      };

      # ----------------------------------------------------------------------
      # Input
      # ----------------------------------------------------------------------
      input = {
        kb_layout = "gb";
        kb_options = "compose:caps";
        follow_mouse = 1;
        sensitivity = 0;
        numlock_by_default = true;
        touchpad = {
          natural_scroll = false;
          clickfinger_behavior = true;
          scroll_factor = 0.4;
        };
      };

      # ----------------------------------------------------------------------
      # Misc
      # ----------------------------------------------------------------------
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_scale_notification = true;
        focus_on_activate = true;
        anr_missed_pings = 3;
        on_focus_under_fullscreen = 1;
        force_default_wallpaper = 0;
        allow_session_lock_restore = true;
      };

      # Cursor
      cursor = {
        hide_on_key_press = true;
        warp_on_change_workspace = 1;
      };

      # Binds
      binds = {
        hide_special_on_workspace_change = true;
      };

      # Ecosystem
      ecosystem = {
        no_update_news = true;
      };

      # XWayland
      xwayland = {
        force_zero_scaling = true;
      };

      # ----------------------------------------------------------------------
      # Launch on session start
      # ----------------------------------------------------------------------
      exec-once = [
        # Import systemd environment (required for some apps)
        "systemctl --user import-environment $(env | cut -d'=' -f 1)"
        "dbus-update-activation-environment --systemd --all"

        # Idle management
        "${pkgs.hypridle}/bin/hypridle"
        # Notification daemon
        "${pkgs.mako}/bin/mako"
        # Status bar
        "${pkgs.waybar}/bin/waybar"
        # Wallpaper (installed by home-manager to ~/.config/hypr/wallpaper.png)
        "${pkgs.swaybg}/bin/swaybg -m fill -i ${config.home.homeDirectory}/.config/hypr/wallpaper.png"
        # Volume/brightness OSD
        "${pkgs.swayosd}/bin/swayosd-server"
        # Polkit authentication agent
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        # Network manager tray icon
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        # Bluetooth tray icon
        "${pkgs.blueman}/bin/blueman-applet"
      ];

      # ----------------------------------------------------------------------
      # Window rules
      # ----------------------------------------------------------------------
      windowrulev2 = [
        # Suppress maximize events globally
        "suppressevent maximize, class:.*"

        # Fix XWayland dragging issues
        "nofocus, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pinned:0"

        # App-specific overrides
        "float, class:^(pavucontrol)$"
        "float, class:^(blueman)$"
        "float, class:^(nm-applet)$"
        "float, class:^(gnome-calculator)$"
        "float, class:^(imv)$"
        "float, title:^(Picture-in-Picture)$"
        "float, title:^(Open File)$"
        "float, title:^(Save As)$"
        "float, title:^(Confirm)$"
        "opacity 0.97 0.9, tag:default-opacity"

        # Scroll nicely in the terminal
        "scroll_touchpad 1.5, class:(ghostty|wezterm)"

      ];

      # ----------------------------------------------------------------------
      # Mouse bindings
      # ----------------------------------------------------------------------
      bindm = [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
        "${mod}, mouse_down, workspace, e+1"
        "${mod}, mouse_up, workspace, e-1"
      ];

      # ----------------------------------------------------------------------
      # Keybindings
      # ----------------------------------------------------------------------
      bind = [
        # ── Application launching ──
        "${mod}, Return, exec, ${pkgs.ghostty}/bin/ghostty"
        "${mod} SHIFT, Return, exec, ${pkgs.ghostty}/bin/ghostty -e tmux new-session -s Work"
        "${mod} SHIFT, B, exec, ${pkgs.chromium}/bin/chromium"
        "${mod} SHIFT, N, exec, ${pkgs.ghostty}/bin/ghostty -e nvim ."
        "${mod} SHIFT, F, exec, ${pkgs.nautilus}/bin/nautilus --new-window"
        "${mod} SHIFT, D, exec, ${pkgs.ghostty}/bin/ghostty -e lazydocker"
        "${mod} SHIFT, G, exec, ${pkgs.signal-desktop}/bin/signal-desktop"
        "${mod} SHIFT, O, exec, ${pkgs.obsidian}/bin/obsidian"

        # ── Window management ──
        "${mod}, W, killactive,"
        "${mod}, T, togglefloating,"
        "${mod}, F, fullscreen,"
        "${mod} CTRL, F, fullscreenstate, 0 2"
        "${mod} ALT, F, fullscreen, maximize"
        "${mod}, J, togglesplit,"
        "${mod}, P, pseudo,"
        "${mod}, O, pin,"
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

        # ── Group navigation (as in Omarchy) ──
        "${mod} ALT, Tab, changegroupactive, 1"
        "${mod} ALT SHIFT, Tab, changegroupactive, -1"
        "${mod} CTRL, Left, changegroupactive, -1"
        "${mod} CTRL, Right, changegroupactive, 1"
        "${mod}, G, togglegroup,"
        "${mod} ALT, G, movewindoworgroup,"

        # ── Universal clipboard (copy/paste/cut in any app incl. terminal) ──
        "${mod}, C, sendshortcut, CTRL, Insert,"
        "${mod}, V, sendshortcut, SHIFT, Insert,"
        "${mod}, X, sendshortcut, CTRL, X,"

        # ── Screenshots ──
        ", Print, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
        "${mod}, Print, exec, ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy"

        # ── Clipboard history ──
        "${mod} CTRL, V, exec, ${pkgs.walker}/bin/walker -m clipboard"

        # ── App launcher & utilities ──
        "${mod}, Space, exec, ${pkgs.walker}/bin/walker"
        "${mod} ALT, Space, exec, ${pkgs.walker}/bin/walker"
        "${mod}, Escape, exec, ${pkgs.wlogout}/bin/wlogout -b 3 -T 500 -B 500"
        "${mod} CTRL, E, exec, ${pkgs.walker}/bin/walker -m symbols"

        # ── System ──
        "${mod} CTRL, L, exec, ${pkgs.hyprlock}/bin/hyprlock"
        "${mod} SHIFT, Space, exec, pkill waybar || ${pkgs.waybar}/bin/waybar"
        "${mod}, Backspace, exec, hyprctl keyword decoration:active_opacity 0.85"
        "${mod} SHIFT, Backspace, exec, hyprctl keyword general:gaps_in 0 && hyprctl keyword general:gaps_out 0"
        "${mod} SHIFT, C, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a"

        # ── Notifications ──
        "${mod}, Comma, exec, ${pkgs.mako}/bin/makoctl dismiss"
        "${mod} SHIFT, Comma, exec, ${pkgs.mako}/bin/makoctl dismiss --all"
        "${mod} ALT, Comma, exec, ${pkgs.mako}/bin/makoctl invoke"
        "${mod} SHIFT ALT, Comma, exec, ${pkgs.mako}/bin/makoctl restore"

        # ── Toggles ──
        "${mod} CTRL, I, exec, pgrep -x hypridle >/dev/null && pkill hypridle || ${pkgs.hypridle}/bin/hypridle"
        "${mod} CTRL, N, exec, pgrep -x hyprsunset >/dev/null && pkill hyprsunset || ${pkgs.hyprsunset}/bin/hyprsunset -t 4000"
        "${mod} CTRL, T, exec, ${pkgs.ghostty}/bin/ghostty -e btop"

        # ── Media (with SwayOSD feedback) ──
        ", XF86AudioRaiseVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume lower"
        ", XF86AudioMute, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle"
        ", XF86AudioMicMute, exec, ${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
        "SHIFT, XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 100%"
        "SHIFT, XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%"
        "ALT, XF86AudioRaiseVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume +1"
        "ALT, XF86AudioLowerVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume -1"
        "ALT, XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%+"
        "ALT, XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 1%-"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
      ];
    };
  };

  # --------------------------------------------------------------------------
  # XCompose file for emoji and special characters (as in Omarchy)
  # --------------------------------------------------------------------------
  home.file.".XCompose".text = ''
    include "%L"

    # Emoji
    <Multi_key> <m> <s> : "😄" # smile
    <Multi_key> <m> <c> : "😂" # cry
    <Multi_key> <m> <l> : "😍" # love
    <Multi_key> <m> <v> : "✌️"  # victory
    <Multi_key> <m> <h> : "❤️"  # heart
    <Multi_key> <m> <y> : "👍" # yes
    <Multi_key> <m> <n> : "👎" # no
    <Multi_key> <m> <f> : "🖕" # fuck
    <Multi_key> <m> <w> : "🤞" # wish
    <Multi_key> <m> <r> : "🤘" # rock
    <Multi_key> <m> <k> : "😘" # kiss
    <Multi_key> <m> <e> : "🙄" # eyeroll
    <Multi_key> <m> <d> : "🤤" # droll
    <Multi_key> <m> <m> : "💰" # money
    <Multi_key> <m> <x> : "🎉" # xellebrate
    <Multi_key> <m> <1> : "💯" # 100%
    <Multi_key> <m> <t> : "🥂" # toast
    <Multi_key> <m> <p> : "🙏" # pray
    <Multi_key> <m> <i> : "😉" # wink
    <Multi_key> <m> <o> : "👌" # OK
    <Multi_key> <m> <g> : "👋" # greeting
    <Multi_key> <m> <a> : "💪" # arm
    <Multi_key> <m> <b> : "🤯" # blowing

    # Typography
    <Multi_key> <space> <space> : "—"
  '';

  # Wallpaper (copied from the Omarchy Tokyo Night theme)
  home.file.".config/hypr/wallpaper.png".source = ../../wallpapers/tokyo-night.jpg;

  # Screen share picker CSS
  xdg.configFile."hypr/hyprland-preview-share-picker.css".text = ''
    @define-color foreground #${theme.foreground};
    @define-color background #${theme.background};
    @define-color accent #${theme.accent};
    @define-color muted #${theme.color8};
    @define-color card_bg #${theme.color0};
    @define-color text_dark #${theme.background};
    @define-color accent_hover #${theme.color12};
    @define-color selected_tab #${theme.accent};
    @define-color text #${theme.foreground};

    * {
      all: unset;
      font-family: JetBrains Mono NF;
      color: @foreground;
      font-weight: bold;
      font-size: 16px;
    }

    .window {
      background: alpha(@background, 0.95);
      border: solid 2px @accent;
      margin: 4px;
      padding: 18px;
    }

    tabs {
        padding: 0.5rem 1rem;
    }

    tabs > tab {
        margin-right: 1rem;
    }

    .tab-label {
        color: @text;
        transition: all 0.2s ease;
    }

    tabs > tab:checked > .tab-label, tabs > tab:active > .tab-label {
        text-decoration: underline currentColor;
        color: @selected_tab;
    }

    tabs > tab:focus > .tab-label {
        color: @foreground;
    }

    .page {
        padding: 1rem;
    }

    .image-label {
        font-size: 12px;
        padding: 0.25rem;
    }

    flowboxchild > .card, button > .card {
        transition: all 0.2s ease;
        border: solid 2px transparent;
        border-color: @background;
        border-radius: 5px;
        background-color: @card_bg;
        padding: 5px;
    }

    flowboxchild:hover > .card, button:hover > .card, flowboxchild:active > .card, flowboxchild:selected > .card, button:active > .card, button:selected > .card, button:focus > .card {
        border: solid 2px @accent;
    }

    .image {
        border-radius: 5px;
    }

    .region-button {
        padding: 0.5rem 1rem;
        border-radius: 5px;
        background-color: @accent;
        color: @text_dark;
        transition: all 0.2s ease;
    }

    .region-button > label {
        color: @text_dark;
    }

    .region-button:not(:disabled):hover, .region-button:not(:disabled):focus {
        background-color: @accent_hover;
        color: @text_dark;
    }

    .region-button:disabled {
        background-color: @muted;
        color: @background;
    }
  '';
}
