{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Chris Wren";
        email = "chriswrendeveloper@gmail.com";
      };

      alias = {
        cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        root = "rev-parse --show-toplevel";
      };

      branch.autosetuprebase = "always";
      color.ui = true;
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

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
