# Stage 3: Hyprland Desktop

Replace KDE Plasma 6 with Hyprland as the primary desktop environment. Configure Waybar, keybindings, window management, and autostart — all wired to NixOS equivalents of Omarchy commands.

## What This Stage Accomplishes

1. Remove KDE/SDDM, configure Hyprland as the session
2. Set up Hyprland via Home Manager with Omarchy's keybindings
3. Configure Waybar with theme colors
4. Adapt Omarchy's autostart to NixOS-native equivalents
5. Set up screen locking, idle management, notifications

## Files to Create/Modify

### New Files
- `modules/home-manager/hyprland/default.nix` — Hyprland config module
- `modules/home-manager/hyprland/autostart.nix` — Startup apps
- `modules/home-manager/hyprland/bindings.nix` — Keybindings
- `modules/home-manager/hyprland/looknfeel.nix` — Visual settings
- `modules/home-manager/hyprland/windows.nix` — Window rules
- `modules/home-manager/waybar/default.nix` — Waybar status bar

### Modified Files
- `flake.nix` — Add hyprland-plugins, hyprlock, hypridle inputs if needed
- `modules/nixos/x86_64-linux.nix` — Remove KDE/SDDM, add Hyprland session
- `machines/beelink-ser8/home.nix` — Import hyprland + waybar modules
- `machines/surface-book-2/home.nix` — Import hyprland + waybar modules

## Implementation Details

### 1. System-Level Changes (`modules/nixos/x86_64-linux.nix`)

Replace KDE Plasma 6 with Hyprland:

```nix
{ config, pkgs, lib, ... }:
{
  # Remove KDE
  # services.displayManager.sddm.enable = lib.mkForce false;
  # services.desktopManager.plasma6.enable = lib.mkForce false;

  # Hyprland session
  programs.hyprland.enable = true;

  # Login manager (SDDM in Wayland mode for Hyprland)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "tokyo-night";  # Or your preferred SDDM theme
  };

  # Screen locking
  security.pam.services.hyprlock = {};

  # XDG portal for screen sharing, file dialogs
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Polkit for privilege escalation UI
  programs.polkit.enable = true;

  # Networking (NetworkManager already enabled)
  # Bluetooth (already enabled)
  # Audio (PipeWire already enabled)

  # System packages needed by Hyprland
  environment.systemPackages = with pkgs; [
    # Existing
    google-chrome
    firefox
    killall
    xclip
    gnupg
    pinentry
    pinentry-curses

    # New for Hyprland
    swaybg           # Wallpaper
    swaylock          # Screen lock (fallback)
    wl-clipboard      # Wayland clipboard
    grim              # Screenshot
    slurp             # Region select
    wf-recorder       # Screen recording
    hyprpicker        # Color picker
    playerctl         # Media controls
    brightnessctl     # Backlight control
    pavucontrol       # Audio control UI
    networkmanagerapplet  # Network tray
  ];
}
```

### 2. Hyprland Module (`modules/home-manager/hyprland/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  theme = config.theme.colors;
  mod = "SUPER";
in {
  options.hyprland = {
    enable = lib.mkEnableOption "Hyprland window manager";
  };

  imports = [
    ./autostart.nix
    ./bindings.nix
    ./looknfeel.nix
    ./windows.nix
  ];

  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      settings = {
        # General
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgb(${theme.accent}) rgb(${theme.color4}) 45deg";
          "col.inactive_border" = "rgb(${theme.color0})";
          layout = "dwindle";
          allow_tearing = false;
        };

        # Decoration
        decoration = {
          rounding = 0;
          blur = {
            enabled = true;
            size = 3;
            passes = 2;
            brightness = 0.60;
          };
          shadow = {
            enabled = true;
            range = 2;
            render_power = 3;
          };
        };

        # Animations
        animations = {
          enabled = true;
          bezier = "easeOutQuint, 0.23, 1, 0.32, 1";
          windows = {
            speed = 200;
            bezier = "easeOutQuint";
            size = "100%";
          };
          windowsIn = "default 20% 70% easeOutQuint";
          windowsOut = "default 20% 70% easeOutQuint fadeIn";
          fade = {
            speed = 200;
            bezier = "easeOutQuint";
          };
        };

        # Input
        input = {
          kb_layout = "gb";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
          };
        };

        # Misc
        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };
      };
    };
  };
}
```

### 3. Keybindings (`modules/home-manager/hyprland/bindings.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  mod = "SUPER";
  theme = config.theme.colors;
in {
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        # Applications
        "${mod}, Return, exec, ghostty"
        "${mod} SHIFT, Return, exec, ghostty -e tmux new-session -s Work"
        "${mod} SHIFT, B, exec, google-chrome"
        "${mod} SHIFT, N, exec, ghostty -e nvim ."
        "${mod} SHIFT, F, exec, nautilus"
        "${mod} SHIFT, D, exec, ghostty -e lazydocker"
        "${mod} SHIFT, G, exec, signal-desktop"
        "${mod} SHIFT, O, exec, obsidian"
        "${mod} SHIFT, M, exec, spotify"

        # Window management
        "${mod}, W, killactive,"
        "${mod}, T, togglefloating,"
        "${mod}, F, fullscreen,"
        "${mod} ALT, F, maximize,"
        "${mod}, J, togglesplit,"
        "${mod}, P, pseudo,"
        "${mod}, O, pin,"
        "${mod}, L, layoutmsg, togglesplit"
        "${mod}, G, togglegroup,"
        "${mod} SHIFT, S, movetoworkspace, special:scratchpad"

        # Workspaces
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

        # Move to workspace
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

        # Focus
        "${mod}, H, movefocus, l"
        "${mod}, L, movefocus, r"
        "${mod}, K, movefocus, u"
        "${mod}, J, movefocus, d"

        # Resize (Alt+Arrow for resize mode)
        "${mod} ALT, H, resizeactive, -20 0"
        "${mod} ALT, L, resizeactive, 20 0"
        "${mod} ALT, K, resizeactive, 0 -20"
        "${mod} ALT, J, resizeactive, 0 20"

        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "${mod}, Print, exec, grim - | wl-copy"

        # App launcher
        "${mod}, Space, exec, walker"
        "${mod}, Escape, exec, walker --plugins-system-dir /etc/walker"
        "${mod} ALT, Space, exec, walker --plugins-system-dir /etc/walker"

        # System
        "${mod} CTRL, L, exec, hyprlock"
        "${mod} SHIFT, Space, exec, pkill waybar || waybar"
        "${mod} CTRL, V, exec, cliphist list | wofi --dmenu | wl-copy"
        "${mod} BACKSPACE, exec, hyprctl keyword decoration:active_opacity 0.85"
        "${mod} SHIFT, BACKSPACE, exec, hyprctl keyword general:gaps_in 0 && hyprctl keyword general:gaps_out 0"
        "${mod}, C, exec, hyprpicker -a"

        # Media (work even when locked)
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindm = [
        # Mouse bindings
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];
    };
  };
}
```

### 4. Autostart (`modules/home-manager/hyprland/autostart.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  # NixOS equivalents of Omarchy autostart commands
  startup = [
    # Idle management
    "hypridle"
    # Notification daemon
    "mako"
    # Status bar
    "waybar"
    # Input method (optional)
    # "fcitx5"
    # Wallpaper
    "swaybg -m fill -i ${config.home.homeDirectory}/.config/hypr/wallpaper.png"
    # Polkit authentication agent
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
    # Network manager tray icon
    "nm-applet --indicator"
    # Bluetooth tray icon
    "blueman-applet"
  ];
in {
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = startup;
    };
  };
}
```

### 5. Waybar Module (`modules/home-manager/waybar/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  theme = config.theme.colors;
in {
  options.waybar = {
    enable = lib.mkEnableOption "Waybar status bar";
  };

  config = lib.mkIf config.waybar.enable {
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
          };

          network = {
            format-wifi = "{signalStrength}% ";
            format-ethernet = "{ifname} ";
            format-disconnected = "";
            tooltip-format = "{ipaddr}/{cidr}";
          };

          pulseaudio = {
            format = "{volume}% {icon}";
            format-muted = " muted";
            format-icons = {
              default = ["", "", ""];
            };
          };

          cpu = {
            format = "{usage}% ";
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-icons = ["", "", "", "", "", "", "", "", "", ""];
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

        #clock, #battery, #cpu, #pulseaudio, #network, #bluetooth, #tray {
          padding: 0 10px;
        }
      '';
    };
  };
}
```

## Verification

1. `nixos-rebuild switch` succeeds on both machines
2. SDDM shows Hyprland session option
3. Hyprland starts with correct keybindings
4. Waybar shows with theme colors
5. `SUPER+Return` opens Ghostty
6. `SUPER+Space` opens Walker (if configured in Stage 4)
7. Wallpapers load
8. Volume/brightness keys work
