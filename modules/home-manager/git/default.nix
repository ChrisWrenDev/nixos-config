{...}:
{
    programs.git = {
    enable = true;
    userName = "Chris Wren";
    userEmail = "chriswrendeveloper@gmail.com";
    signing = {
      key = "~/.ssh/id_ed25519.pub";
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
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "chriswrendev";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };
}
