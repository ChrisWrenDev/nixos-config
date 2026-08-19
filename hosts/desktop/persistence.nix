{config, ...}: {
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/systemd"
      "/var/log"
      "/etc/nixos"
    ];
  };
}
