{
  config,
  lib,
  pkgs,
  ...
}:
let
  theme = config.theme.colorsHex;
in
{
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
          format = "";
          format-connected = " {num_devices}";
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
            default = [
              " "
              " "
              " "
            ];
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
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
          ];
        };

        tray = {
          spacing = 10;
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
    '';
  };
}
