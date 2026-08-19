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
        openai = {
          npm = "@ai-sdk/openai";
          name = "OpenAI";
          options = {
            apiKey = "{file:${secretsDir}/openai-api-key}";
          };
        };
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (local)";
          options = {
            baseURL = "http://localhost:11434/v1";
          };
          models = {
            "llama3.1" = {name = "Llama 3.1";};
            "qwen2.5-coder" = {name = "Qwen 2.5 Coder";};
            "codellama" = {name = "Code Llama";};
          };
        };
      };
    };
  };
}
