{ config, lib, ... }:
{
  options.programs.opencode-custom = {
    enable = lib.mkEnableOption "OpenCode configuration";
  };

  config = lib.mkIf config.programs.opencode-custom.enable {
    xdg.configFile."opencode/opencode.json".source = ./opencode.json;
  };
}
