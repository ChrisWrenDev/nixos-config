{
  config,
  lib,
  ...
}:
let
  cfg = config.theme;

  # Auto-discover color themes from `themes/*.nix`
  themes = lib.mapAttrs' (
    name: _:
    let
      cleanName = lib.removeSuffix ".nix" name;
    in
    lib.nameValuePair cleanName (import ../../themes/${cleanName}.nix)
  ) (builtins.readDir ../../themes);

  currentTheme = themes.${cfg.active};

  # Helper: strip leading "#" from a hex color
  stripHash = color: lib.removePrefix "#" color;

  # Helper: convert "RRGGBB" hex into an "R, G, B" tuple string for CSS rgba()
  hexToRgb =
    hex:
    let
      s = stripHash hex;
    in
    "${lib.toInt (lib.substring 0 2 s)}, ${lib.toInt (lib.substring 2 2 s)}, ${
      lib.toInt (lib.substring 4 2 s)
    }";
in
{
  options.theme = {
    active = lib.mkOption {
      type = lib.types.enum (builtins.attrNames themes);
      default = "tokyo-night";
      description = "Active color theme. Must be one of the available themes.";
    };

    # Raw hex colors without "#" prefix (as stored in themes/*.nix)
    colors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
      description = "Current theme color values in #RRGGBB form.";
    };

    # Hex colors with "#" prefix
    colorsHex = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
      description = "Current theme color values in #RRGGBB form.";
    };

    # Colors as "R, G, B" tuples for CSS rgba() usage
    colorsRgb = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      readOnly = true;
      description = "Current theme colors as R, G, B tuples.";
    };

    name = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Display name of the current theme.";
    };
  };

  config = {
    theme.colors = currentTheme.colors;
    theme.name = currentTheme.name;
    theme.colorsHex = lib.mapAttrs (_: color: "#${stripHash color}") currentTheme.colors;
    theme.colorsRgb = lib.mapAttrs (_: color: hexToRgb color) currentTheme.colors;
  };
}
