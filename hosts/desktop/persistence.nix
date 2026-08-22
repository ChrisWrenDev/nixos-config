{config, ...}: {
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/systemd"
      "/var/lib/nixos"
      "/var/log"
      "/etc/nixos"
    ];
  };
}
