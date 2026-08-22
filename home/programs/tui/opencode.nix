{config, ...}: let
  secretsDir = "${config.home.homeDirectory}/.config/opencode/secrets";
in {
  programs.opencode = {
    enable = true;
    settings = {
      model = "anthropic/claude-sonnet-4-20250514";

      provider = {
        zen = {
          npm = "@ai-sdk/openai-compatible";
          name = "OpenCode Zen";
          options = {
            baseURL = "https://opencode.ai/zen/v1";
            apiKey = "{file:${secretsDir}/zen-api-key}";
          };
        };
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options = {
            baseURL = "http://localhost:11434/v1";
          };
          models = {
            "qwen3.8:27b" = {name = "Qwen 3.8";};
            "qwen3.6:35b-a3b" = {name = "Qwen 3.6";};
          };
        };
      };
    };
  };
}
