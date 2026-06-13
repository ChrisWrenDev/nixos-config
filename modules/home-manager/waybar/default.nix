{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.waybar;
  theme = config.theme.colorsHex;
in
{
  options.waybar = {
    enable = lib.mkEnableOption "Waybar status bar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 26;

          modules-left = [
            "hyprland/workspaces"
          ];

          modules-center = [
            "clock"
            "custom/screenrecording-indicator"
            "custom/idle-indicator"
            "custom/notification-silencing-indicator"
          ];

          modules-right = [
            "tray"
            "bluetooth"
            "network"
            "pulseaudio"
            "cpu"
            "battery"
          ];

          "hyprland/workspaces" = {
            format = "{id}";
            on-click = "activate";
            active-only = false;
          };

          clock = {
            format = "{:%H:%M}";
            format-alt = "{:%Y-%m-%d %H:%M}";
            tooltip-format = "<tt>{calendar}</tt>";
          };

          bluetooth = {
            format = "\\\u2713";
            format-connected = " \\\u2713 {num_devices}";
            tooltip-format = "{controller_alias}\t{controller_address}";
            on-click = "blueman-manager";
          };

          network = {
            format-wifi = "{signalStrength}% ";
            format-ethernet = "{ifname} ";
            format-disconnected = "";
            tooltip-format = "{ipaddr}/{cidr}";
            on-click = "nm-connection-editor";
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-muted = " muted";
            format-icons = {
              default = [ "\\\u266a" "\\\u266b" "\\\u266c" ];
            };
            on-click = "pavucontrol";
          };

          cpu = {
            format = "{usage}% ";
            on-click = "ghostty -e btop";
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-icons = [
              "\\\u2581" "\\\u2582" "\\\u2583" "\\\u2584"
              "\\\u2585" "\\\u2586" "\\\u2587" "\\\u2588"
              "\\\u2588" "\\\u2588"
            ];
          };

          tray = {
            spacing = 10;
          };

          "custom/screenrecording-indicator" = {
            exec = "${pkgs.writeShellScript "screenrecording-indicator" ''
              if ${pkgs.procps}/bin/pgrep -f "^gpu-screen-recorder" >/dev/null; then
                echo '{"text": "󰻂", "tooltip": "Stop recording", "class": "active"}'
              else
                echo '{"text": ""}'
              fi
            ''}";
            return-type = "json";
            interval = 5;
            on-click = "${pkgs.writeShellScript "screenrecording-toggle" ''
              if ${pkgs.procps}/bin/pgrep -f "^gpu-screen-recorder" >/dev/null; then
                ${pkgs.procps}/bin/pkill -f "^gpu-screen-recorder"
              else
                ${pkgs.libnotify}/bin/notify-send "Screen recording" "No recording script configured"
              fi
            ''}";
            signal = 8;
          };

          "custom/idle-indicator" = {
            exec = "${pkgs.writeShellScript "idle-indicator" ''
              if ${pkgs.procps}/bin/pgrep -x hypridle >/dev/null; then
                echo '{"text": ""}'
              else
                echo '{"text": "󱫖", "tooltip": "Idle lock disabled", "class": "active"}'
              fi
            ''}";
            return-type = "json";
            interval = 5;
            on-click = "${pkgs.writeShellScript "idle-toggle" ''
              if ${pkgs.procps}/bin/pgrep -x hypridle >/dev/null; then
                ${pkgs.procps}/bin/pkill -x hypridle
                ${pkgs.libnotify}/bin/notify-send "    Stop locking computer when idle"
              else
                ${pkgs.uwsm}/bin/uwsm-app -- hypridle
                ${pkgs.libnotify}/bin/notify-send "    Now locking computer when idle"
              fi
            ''}";
            signal = 9;
          };

          "custom/notification-silencing-indicator" = {
            exec = "${pkgs.writeShellScript "notification-silencing-indicator" ''
              if ${pkgs.mako}/bin/makoctl mode 2>/dev/null | grep -q 'do-not-disturb'; then
                echo '{"text": "󰂛", "tooltip": "Notifications silenced", "class": "active"}'
              else
                echo '{"text": ""}'
              fi
            ''}";
            return-type = "json";
            interval = 5;
            on-click = "${pkgs.writeShellScript "notification-silencing-toggle" ''
              if ${pkgs.mako}/bin/makoctl mode 2>/dev/null | grep -q 'do-not-disturb'; then
                ${pkgs.mako}/bin/makoctl mode -d do-not-disturb
              else
                ${pkgs.mako}/bin/makoctl mode -a do-not-disturb
              fi
            ''}";
            signal = 10;
          };
        };
      };

      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 12px;
        }

        window#waybar {
          background-color: #${theme.background};
          color: #${theme.foreground};
        }

        #workspaces button {
          padding: 0 5px;
          color: #${theme.foreground};
          background-color: transparent;
        }

        #workspaces button.active {
          background-color: #${theme.accent};
          color: #${theme.background};
        }

        #workspaces button.urgent {
          background-color: #${theme.color1};
          color: #${theme.background};
        }

        #clock,
        #battery,
        #cpu,
        #pulseaudio,
        #network,
        #bluetooth,
        #tray {
          padding: 0 10px;
        }

        #battery.warning {
          color: #${theme.color3};
        }

        #battery.critical {
          color: #${theme.color1};
        }

        #custom-screenrecording-indicator,
        #custom-idle-indicator,
        #custom-notification-silencing-indicator {
          min-width: 12px;
          margin-left: 5px;
          margin-right: 0;
          font-size: 10px;
          padding-bottom: 1px;
        }

        #custom-screenrecording-indicator.active {
          color: #${theme.color1};
        }

        #custom-idle-indicator.active,
        #custom-notification-silencing-indicator.active {
          color: #${theme.color1};
        }
      '';
    };
  };
}
