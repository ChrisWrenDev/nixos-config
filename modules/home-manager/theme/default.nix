{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.theme;

  # Helper: strip leading "#" from hex color
  stripHash = color: lib.removePrefix "#" color;

  # Helper: convert hex color "RRGGBB" to "R,G,B" for CSS rgba()
  hexToRgb = hex:
    let
      stripped = stripHash hex;
      r = lib.substring 0 2 stripped;
      g = lib.substring 2 2 stripped;
      b = lib.substring 4 2 stripped;
    in
    "${builtins.fromTOML "x=\"0x${r}\""}.x},${builtins.fromTOML "x=\"0x${g}\""}.x},${builtins.fromTOML "x=\"0x${b}\""}.x}";

  # All color themes (auto-discovered from themes/ directory)
  themes = lib.mapAttrs' (name: _:
    let cleanName = lib.removeSuffix ".nix" name;
    in lib.nameValuePair cleanName (import ../../../themes/${cleanName}.nix)
  ) (builtins.readDir ../../../themes);

  currentTheme = themes.${cfg.active};

  # Map color names to base16 indices for nix-colors
  colorToBase16Index = {
    color0 = 0; color1 = 1; color2 = 2; color3 = 3;
    color4 = 4; color5 = 5; color6 = 6; color7 = 7;
    color8 = 8; color9 = 9; color10 = 10; color11 = 11;
    color12 = 12; color13 = 13; color14 = 14; color15 = 15;
    accent = 12; cursor = 15; foreground = 7;
    background = 0; selection_foreground = 15; selection_background = 12;
  };

  # Build a color scheme for nix-colors from our theme
  nixColorsScheme = lib.mapAttrs' (name: value: {
    name = "base${toString colorToBase16Index.${name}}";
    value = "#${value}";
  }) currentTheme.colors;
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  options.theme = {
    active = lib.mkOption {
      type = lib.types.enum (builtins.attrNames themes);
      default = "tokyo-night";
      description = "Active color theme. Must be one of the available themes.";
    };

    colors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
      description = "Current theme raw hex color values (without # prefix).";
    };

    colorsHex = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
      description = "Current theme hex colors with # prefix.";
    };

    colorsRgb = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
      description = "Current theme colors as R,G,B tuples (no #, no hex).";
    };

    name = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Display name of the current theme.";
    };
  };

  config = {
    # Expose colors in multiple formats
    theme.colors = currentTheme.colors;
    theme.name = currentTheme.name;
    theme.colorsHex = lib.mapAttrs (_: color: "#${color}") currentTheme.colors;
    theme.colorsRgb = lib.mapAttrs (_: color: hexToRgb color) currentTheme.colors;

    # nix-colors integration
    colorScheme = {
      name = cfg.active;
      palette = nixColorsScheme;
    };
  };
}
