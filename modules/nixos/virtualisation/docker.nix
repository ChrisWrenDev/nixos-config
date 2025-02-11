{
  pkgs,
  ...
}: {
  virtualisation = {
    oci-containers.backend = "docker";
    docker.enable = true;
  };

  environment.systemPackages = with pkgs; [lazydocker];

  users.users.chriswrendev.extraGroups = ["docker"];
}
