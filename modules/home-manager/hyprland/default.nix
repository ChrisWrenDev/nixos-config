{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hyprland;
  theme = config.theme.colorsHex;
  mod = "SUPER";
in
{
  imports = [
    ./autostart.nix
    ./bindings.nix
    ./looknfeel.nix
    ./windows.nix
  ];

  options.hyprland = {
    enable = lib.mkEnableOption "Hyprland window manager";
  };

  config = lib.mkIf cfg.enable {
    # XCompose file for emoji and special characters
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

    # Hyprland screen share picker CSS
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

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      settings = {
        # Environment variables
        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "GDK_BACKEND,wayland,x11,*"
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_STYLE_OVERRIDE,kvantum"
          "MOZ_ENABLE_WAYLAND,1"
          "ELECTRON_OZONE_PLATFORM_HINT,wayland"
          "OZONE_PLATFORM,wayland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XCOMPOSEFILE,~/.XCompose"
        ];

        # General
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

        # Decoration
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

        # Animations
        animations = {
          enabled = true;
        };

        # Dwindle layout
        dwindle = {
          preserve_split = true;
          force_split = 2;
        };

        # Master layout
        master = {
          new_status = "master";
        };

        # Input
        input = {
          kb_layout = "gb";
          kb_options = "compose:caps";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad = {
            natural_scroll = false;
          };
        };

        # Misc
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          disable_scale_notification = true;
          focus_on_activate = true;
          anr_missed_pings = 3;
          on_focus_under_fullscreen = 1;
          force_default_wallpaper = 0;
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
      };
    };
  };
}
