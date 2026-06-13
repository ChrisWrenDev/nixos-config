# Stage 1: Theme Foundation

Build the theme system using nix-colors as the color management backbone. This stage creates the infrastructure that all subsequent themed components depend on.

## What This Stage Accomplishes

1. Add `nix-colors` as a flake input
2. Convert all 21 Omarchy themes into Nix attrsets
3. Create a `theme` Home Manager module with color scheme management
4. Provide color variants (hex, rgb, strip) for downstream consumers
5. Update existing Starship config to use theme colors

## Files to Create/Modify

### New Files
- `themes/tokyo-night.nix` (and 20 others) — Theme definitions
- `modules/home-manager/theme/default.nix` — Theme module

### Modified Files
- `flake.nix` — Add nix-colors input
- `flake.lock` — Updated lock file
- `modules/home-manager/starship/default.nix` — Use theme colors
- `machines/beelink-ser8/home.nix` — Import theme module
- `machines/surface-book-2/home.nix` — Import theme module
- `shared/home.nix` — Add theme module import

## Implementation Details

### 1. Add nix-colors to flake.nix

```nix
# In flake inputs:
nix-colors.url = "github:SenchoPens/nix-colors";
```

### 2. Theme Module (`modules/home-manager/theme/default.nix`)

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.theme;

  # Theme definitions
  themes = {
    tokyo-night = {
      name = "Tokyo Night";
      colors = {
        accent = "7aa2f7";
        cursor = "c0caf5";
        foreground = "a9b1d6";
        background = "1a1b26";
        selection_foreground = "c0caf5";
        selection_background = "7aa2f7";
        color0 = "32344a";   # Black
        color1 = "f7768e";   # Red
        color2 = "9ece6a";   # Green
        color3 = "e0af68";   # Yellow
        color4 = "7aa2f7";   # Blue
        color5 = "ad8ee6";   # Magenta
        color6 = "449dab";   # Cyan
        color7 = "787c99";   # White
        color8 = "444b6a";   # Bright Black
        color9 = "ff7a93";   # Bright Red
        color10 = "b9f27c";  # Bright Green
        color11 = "ff9e64";  # Bright Yellow
        color12 = "7da6ff";  # Bright Blue
        color13 = "bb9af7";  # Bright Magenta
        color14 = "0db9d7";  # Bright Cyan
        color15 = "acb0d0";  # Bright White
      };
    };

    # ... (all 21 themes from Omarchy)
  };

  currentTheme = themes.${cfg.active};
in {
  options.theme = {
    active = lib.mkOption {
      type = lib.types.str;
      default = "tokyo-night";
      description = "Active color theme";
    };

    colors = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      description = "Current theme colors (raw hex values)";
    };

    colorsRgb = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      description = "Current theme colors as R,G,B tuples";
    };
  };

  config = {
    theme.colors = currentTheme.colors;

    theme.colorsRgb = lib.mapAttrs'
      (name: value: lib.nameValuePair name (hexToRgb value))
      currentTheme.colors;

    # nix-colors integration
    colorScheme = {
      name = cfg.active;
      palette = lib.mapAttrs'
        (name: value: lib.nameValuePair "base${builtins.toString (fromHexName name)}" "#${value}")
        currentTheme.colors;
    };
  };
};
```

### 3. Theme Definition Format

Each theme in `themes/` follows this pattern:

```nix
# themes/tokyo-night.nix
{
  name = "Tokyo Night";
  colors = {
    accent = "7aa2f7";
    cursor = "c0caf5";
    foreground = "a9b1d6";
    background = "1a1b26";
    selection_foreground = "c0caf5";
    selection_background = "7aa2f7";
    color0 = "32344a";
    color1 = "f7768e";
    # ... (all 16 terminal colors)
    color15 = "acb0d0";
  };
}
```

### 4. Starship Integration

Update `modules/home-manager/starship/default.nix` to use theme colors:

```nix
{ config, ... }:
let
  theme = config.theme.colors;
in {
  programs.starship.settings = {
    format = "[░▒▓](##{theme.accent})[ ... ]";
    # Use theme colors throughout
    directory.style = "fg:${theme.foreground} bg:${theme.accent}";
    # etc.
  };
}
```

## Verification

1. `nix flake check` passes
2. `nix build .#homeManagerConfigurations.chriswrendev@beelink-ser8.activationPackage` builds
3. Theme colors are accessible in Home Manager configs
4. Starship renders with theme colors
