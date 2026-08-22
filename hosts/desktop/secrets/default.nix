{
  pkgs,
  config,
  ...
}: let
  username = config.var.username;
  home = "/home/${username}";
in {
  sops = {
    age.keyFile = "${home}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      hashed-password = {};
      opencode-zen-api-key = {
        owner = username;
        mode = "0600";
        path = "${home}/.config/opencode/secrets/zen-api-key";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    sops
    age
  ];
}
