{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.voxtype-custom;
in
{
  options.programs.voxtype-custom = {
    enable = lib.mkEnableOption "Voxtype voice dictation";
  };

  config = lib.mkIf cfg.enable {
    # Voxtype config file
    xdg.configFile."voxtype/config.toml".text = ''
      # Voxtype Configuration
      state_file = "auto"

      [hotkey]
      enabled = false

      [audio]
      device = "default"
      sample_rate = 16000
      max_duration_secs = 60

      [whisper]
      model = "base.en"
      language = "en"
      translate = false

      [output]
      mode = "type"
      fallback_to_clipboard = true
      type_delay_ms = 1

      [output.notification]
      on_recording_start = false
      on_recording_stop = false
      on_transcription = false
    '';
  };
}
