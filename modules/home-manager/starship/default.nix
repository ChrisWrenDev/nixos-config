{
  config,
  lib,
  ...
}: let
  theme = config.theme.colorsHex;
in {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = "[░▒▓](${theme.color8})[ 󰊠 ](bg:${theme.accent} fg:${theme.background})[ ](bg:${theme.color4} fg:${theme.accent})$directory[](fg:${theme.color4} bg:${theme.color5})$git_branch$git_status[](fg:${theme.color5} bg:${theme.color6})$nodejs$rust$golang$lua$zig[](fg:${theme.color6} bg:${theme.color7})$time[ ](fg:${theme.color7})\n$character";

      directory = {
        style = "fg:${theme.foreground} bg:${theme.color4}";
        format = "[ $path ]($style)";
        read_only = " 󰌾";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "bg:${theme.color5}";
        format = "[[ $symbol $branch ](fg:${theme.color4} bg:${theme.color5})]($style)";
      };

      git_status = {
        style = "bg:${theme.color5}";
        format = "[[($all_status$ahead_behind )](fg:${theme.color4} bg:${theme.color5})]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:${theme.color6}";
        format = "[[ $symbol ($version) ](fg:${theme.color4} bg:${theme.color6})]($style)";
      };

      rust = {
        symbol = "🦀";
        style = "bg:${theme.color6}";
        format = "[[ $symbol ($version) ](fg:${theme.color4} bg:${theme.color6})]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:${theme.color6}";
        format = "[[ $symbol ($version) ](fg:${theme.color4} bg:${theme.color6})]($style)";
      };

      lua = {
        symbol = "🌙";
        style = "bg:${theme.color6}";
        format = "[[ $symbol ($version) ](fg:${theme.color4} bg:${theme.color6})]($style)";
      };

      zig = {
        symbol = "↯";
        style = "bg:${theme.color6}";
        format = "[[ $symbol ($version) ](fg:${theme.color4} bg:${theme.color6})]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:${theme.color7}";
        format = "[[  $time ](fg:${theme.foreground} bg:${theme.color7})]($style)";
      };
    };
  };
}
