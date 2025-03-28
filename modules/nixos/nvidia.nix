{ config, lib, ... }:
{
 # NVIDIA GPU support

  # Enable OpenGL
  hardware.graphics.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Driver version for specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    # version = "546.33";
    version = "517.48";
    sha256_64bit = "";
    sha256_aarch64 = "";
    openSha256 = "";
    settingsSha256 = "";
    persistencedSha256 = lib.fakeSha256;
  };

    # Use Nvidia Prime to choose which GPU (iGPU or eGPU) to use.
    prime = {
        sync.enable = true;
        allowExternalGpu = true;

        # Make sure to use the correct Bus ID values for your system!
        nvidiaBusId = "PCI:127:0:0";
        intelBusId = "PCI:0:2:0";
    };
  };

}
