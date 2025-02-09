{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../shared
    ../../modules/nixos/desktop
    ../../modules/nixos/desktop/awesome
    ../../modules/nixos/desktop/hyprland
    ../../modules/nixos/virtualisation
  ];

  networking = {
    hostName = "chriswrendev";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 22 3000 6666 8081];

      # Facilitate firewall punching
      allowedUDPPorts = [41641];

      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };

  boot = {
    binfmt.emulatedSystems = ["aarch64-linux"];

    plymouth = {
      enable = true;
      theme = "spinner-monochrome";
      themePackages = [
        (pkgs.plymouth-spinner-monochrome.override {inherit (config.boot.plymouth) logo;})
      ];
    };

    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=auto"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelPackages = pkgs.linuxPacikages_surface;
    
    initrd.kernelModules = [
        "intel_lpss_pci"
        "surface_aggregator"  # Required for touch, keyboard, battery
        "surface_acpi"        # Battery and power support
        "surface_sam"         # Sensors and power
        "surface_hid"         # Touchscreen, pen input
    ];
    
    kernelModules = [
        "surface_serial_hub"
        "surface_sam_sid_vhf"
    ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      timeout = 1;
    };
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    graphics.enable32Bit = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    enableEmergencyMode = false;

    user = {
      services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };

  programs = {
    ssh.startAgent = true;
    xfconf.enable = true;
    file-roller.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
    nm-applet.enable = true;
    noisetorch.enable = true;
  };

  services = {
    resolved.enable = true;
    flatpak.enable = true;

    udev.packages = [ pkgs.linux-surface-udev-rules ];

    surface-control.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    logind = {
      extraConfig = "HandlePowerKey=suspend";
      lidSwitch = "suspend";
      lidSwitchExternalPower = "suspend";
    };

    xrdp = {
      enable = true;
      openFirewall = true;
      defaultWindowManager = "awesome";
      audio.enable = true;
    };

    syncthing = {
      enable = true;
      user = "tux";
      dataDir = "/home/tux/";
      openDefaultPorts = true;
    };
    
    xserver = {
      enable = true;
      xkb = {
        layout = "in";
        variant = "eng";
      };
    };

    libinput.touchpad.naturalScrolling = true;

    # To use Auto-cpufreq we need to
    # disable TLP because it's enabled by nixos-hardware
    tlp.enable = false;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
          scaling_min_freq = 400000;
          scaling_max_freq = 3800000;
        };
        charger = {
          governor = "powersave";
          turbo = "never";
          scaling_max_freq = 3800000;
        };
      };
    };

    blueman.enable = true;

    supergfxd = {
      enable = true;
      settings = {
        mode = "Integrated";
        vfio_enable = false;
        vfio_save = false;
        always_reboot = false;
        no_logind = false;
        logout_timeout_s = 180;
        hotplug_type = "None";
      };
    };

    asusd = {
      enable = true;
      enableUserService = true;
      asusdConfig.text = ''
        (
          charge_control_end_threshold: 100,
          panel_od: false,
          mini_led_mode: false,
          disable_nvidia_powerd_on_battery: true,
          ac_command: "",
          bat_command: "",
          platform_policy_on_battery: Quiet,
          platform_policy_on_ac: Quiet,
          ppt_pl1_spl: None,
          ppt_pl2_sppt: None,
          ppt_fppt: None,
          ppt_apu_sppt: None,
          ppt_platform_sppt: None,
          nv_dynamic_boost: None,
          nv_temp_target: None,
        )
      '';
      profileConfig.text = ''
        (
          active_profile: Quiet,
        )
      '';
    };

    gvfs.enable = true;
    tumbler.enable = true;
    gnome.gnome-keyring.enable = true;
    tailscale = {
      enable = true;
      extraUpFlags = ["--login-server https://hs.tux.rs"];
    };
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    jetbrains-mono
  ];

  programs.fuse.userAllowOther = true;

  system.stateVersion = "24.11";

# Common file config
  
  nixpkgs.overlays = import ../../lib/overlays.nix;

  nixpkgs.config = {
    allowUnfree = true;
    joypixels.acceptLicense = true;
  };
  
  nix.package = pkgs.lix;
  nix.settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      trusted-users = ["${username}"];
      warn-dirty = false;
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://anyrun.cachix.org"
        "https://fufexan.cachix.org"
        "https://helix.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://yazi.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      ];
    };

    security.sudo.wheelNeedsPassword = false;

    programs = {
    zsh.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 5d --keep 5";
      flake = "/home/${username}/Projects/nixos-config";
    };
  };
}
