# Stage 4: Supporting Services

Configure the supporting desktop services that make Hyprland functional: notifications (Mako), screen lock (Hyprlock), idle management (Hypridle), app launcher (Walker), and volume/brightness OSD (SwayOSD).

## What This Stage Accomplishes

1. Configure Mako notification daemon with theme colors
2. Set up Hyprlock screen lock with theme-aware appearance
3. Configure Hypridle for automatic locking/suspending
4. Set up Walker app launcher with theme styling
5. Configure SwayOSD for volume/brightness overlays

## Files to Create/Modify

### New Files
- `modules/home-manager/mako/default.nix` — Notification daemon
- `modules/home-manager/hyprlock/default.nix` — Screen lock
- `modules/home-manager/hypridle/default.nix` — Idle management
- `modules/home-manager/walker/default.nix` — App launcher
- `modules/home-manager/swayosd/default.nix` — Volume/brightness OSD

### Modified Files
- `machines/beelink-ser8/home.nix` — Import new modules
- `machines/surface-book-2/home.nix` — Import new modules
- `modules/home-manager/hyprland/autostart.nix` — Reference new services

## Implementation Details

### 1. Mako Notifications (`modules/home-manager/mako/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  theme = config.theme.colors;
in {
  options.mako = {
    enable = lib.mkEnableOption "Mako notification daemon";
  };

  config = lib.mkIf config.mako.enable {
    services.mako = {
      enable = true;

      settings = {
        # Position
        anchor = "top-right";
        margin = "20";
        width = 420;
        height = 150;
        max-visible = 5;

        # Appearance
        border-size = 2;
        border-color = "#${theme.accent}";
        border-radius = 0;
        padding = 15;
        margin-icon = "10";

        # Colors
        background-color = "#${theme.background}";
        color = "#${theme.foreground}";
        text-color = "#${theme.foreground}";

        # Behavior
        default-timeout = 5000;
        ignore-timeout = 1;
        max-icon-size = 32;
        max-image-size = 128;
        actions = true;
        clickable = true;
        close = true;
        close-on-click = true;

        # Font
        font = "JetBrainsMono Nerd Font 10";

        # Hidden apps
        "app-name=Spotify" = {
          hidden = true;
        };
      };
    };
  };
}
```

### 2. Hyprlock (`modules/home-manager/hyprlock/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  theme = config.theme.colors;
in {
  options.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock screen lock";
  };

  config = lib.mkIf config.hyprlock.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          ignore_empty_input = true;
          hide_cursor = true;
        };

        background = {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.6;
          vibrancy = 0.2;
          vibrancy_darkness = 0.5;
        };

        input-field = {
          monitor = "";
          size = "300, 50";
          outline_thickness = 2;
          dots_size = 0.25;
          dots_spacing = 0.15;
          dots_center = true;
          outer_color = "rgb(${theme.accent})";
          inner_color = "rgb(${theme.color0})";
          font_color = "rgb(${theme.foreground})";
          fade_on_empty = false;
          placeholder_text = "";
          hide_input = false;
          position = "0, -120";
          halign = "center";
          valign = "center";
        };

        # Clock
        "0" = {
          monitor = "";
          text = "cmd[update:1000] echo $(date +\"%H:%M\")";
          color = "rgb(${theme.foreground})";
          font_size = 120;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 80";
          halign = "center";
          valign = "center";
        };

        # Date
        "1" = {
          monitor = "";
          text = "cmd[update:60000] echo $(date +\"%A, %d %B %Y\")";
          color = "rgb(${theme.foreground})";
          font_size = 24;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -80";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
```

### 3. Hypridle (`modules/home-manager/hypridle/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  timeout = {
    screensaver = 150;     # 2.5 minutes
    lock = 300;            # 5 minutes
    dim = 330;             # 5.5 minutes
    suspend = 1800;        # 30 minutes
  };
in {
  options.hypridle = {
    enable = lib.mkEnableOption "Hypridle idle management";
  };

  config = lib.mkIf config.hypridle.enable {
    services.hypridle = {
      enable = true;

      settings = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";

        listener = [
          # Dim screen
          {
            timeout = timeout.dim;
            on-timeout = "brightnessctl -s set 30";
            on-resume = "brightnessctl -r";
          }
          # Lock screen
          {
            timeout = timeout.lock;
            on-timeout = "loginctl lock-session";
          }
          # Turn off screen
          {
            timeout = timeout.screensaver;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          # Suspend
          {
            timeout = timeout.suspend;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
```

### 4. Walker App Launcher (`modules/home-manager/walker/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  theme = config.theme.colors;
in {
  options.walker = {
    enable = lib.mkEnableOption "Walker app launcher";
  };

  config = lib.mkIf config.walker.enable = {
    programs.walker = {
      enable = true;

      settings = {
        # Appearance
        width = 644;
        height = 300;
        maxheight = 300;
        placeholder = "Search...";

        # Font
        font = "JetBrainsMono Nerd Font";
        font_size = 18;

        # Behavior
        show_initially = false;
        sort_by_usage = true;
        hide_if_single = true;
        term = "ghostty";

        # Providers
        providers = [
          "desktops"
          "applications"
          "runner"
          "calculator"
          "clipboard"
          "files"
          "symbols"
        ];

        # Search prefixes
        prefixes = [
          { prefix = "/"; source = "websearch"; }
          { prefix = "."; source = "files"; }
          { prefix = ":"; source = "symbols"; }
          { prefix = "="; source = "calculator"; }
          { prefix = "@"; source = "websearch"; }
          { prefix = "$"; source = "clipboard"; }
        ];
      };

      style = ''
        * {
          font-family: "JetBrainsMono Nerd Font";
          font-size: 18px;
        }

        window {
          background-color: rgba(${builtins.fromTOML (builtins.readFile config.home.homeDirectory + "/.config/walker/colors.toml")}.background}, 0.95);
          border: 2px solid #${theme.accent};
          border-radius: 0;
        }

        #input {
          background-color: #${theme.color0};
          color: #${theme.foreground};
          border: none;
          padding: 10px;
        }

        #entry {
          padding: 5px;
          color: #${theme.foreground};
        }

        #entry:selected {
          background-color: #${theme.accent};
          color: #${theme.background};
        }
      '';
    };
  };
}
```

### 5. SwayOSD (`modules/home-manager/swayosd/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  theme = config.theme.colors;
in {
  options.swayosd = {
    enable = lib.mkEnableOption "SwayOSD volume/brightness overlay";
  };

  config = lib.mkIf config.swayosd.enable = {
    programs.swayosd = {
      enable = true;
    };

    xdg.configFile."swayosd/config.toml".text = ''
      [general]
      max_volume = 100
      show_percentage = true
      show_icon = true

      [style]
      css_path = "${./swayosd.css}"
    '';

    xdg.configFile."swayosd/style.css".text = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
      }

      window#osd {
        background-color: rgba(${theme.color0}, 0.9);
        border: 2px solid #${theme.accent};
        border-radius: 0;
        padding: 10px 20px;
      }

      progressbar {
        background-color: #${theme.color8};
        color: #${theme.accent};
        min-height: 8px;
      }

      image {
        color: #${theme.foreground};
      }
    '';
  };
}
```

## Verification

1. `nixos-rebuild switch` succeeds
2. Notifications appear with theme colors (test: `notify-send "Test" "Hello"`)
3. `SUPER+CTRL+L` locks screen with themed lock screen
4. Screen dims after 5.5 min idle, locks after 5 min
5. `SUPER+Space` opens Walker with theme styling
6. Volume keys show SwayOSD overlay
7. Brightness keys show SwayOSD overlay
