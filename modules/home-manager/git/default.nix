{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.git-custom;
  theme = config.theme.colorsHex;
in
{
  options.programs.git-custom = {
    enable = lib.mkEnableOption "Git configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
    enable = true;
    delta.enable = true;
    userName = "Chris Wren";
    userEmail = "chriswrendeveloper@gmail.com";

    signing = {
      key = "";
      signByDefault = true;
    };

    aliases = {
      cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };

    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = "";
      credential.helper = "cache";
      github.user = "chriswrendev";
      push.default = "tracking";
      init.defaultBranch = "main";
      pull.rebase = true;
      rerere.enabled = true;
      diff.algorithm = "histogram";
      merge.conflictstyle = "diff3";
    };
  };
  };
}
