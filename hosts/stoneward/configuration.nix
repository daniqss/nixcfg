{
  config,
  pkgs,
  ...
}: {
  config = {
    common = {
      boot.secureBoot.enable = true;

      tailscale = {
        enable = true;
        role = "client";
      };

      binfmt = {
        enable = true;
        emulatedSystems = ["armv6l-linux" "aarch64-linux"];
      };

      syncthing.enable = false;
    };

    desktop = {
      enable = true;
      gaming.enable = true;

      # kernel and scx_full-1.1.3 desajustement, so disable for now
      # lavd.enable = config.desktop.gaming.enable;

      vm = {
        podman.enable = true;
        libvirt.enable = true;

        virtualbox = {
          enable = false;
          guest.enable = false;
        };
      };
    };

    server.enable = false;

    # nvidia config
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement.enable = true;
    };
    boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    system.stateVersion = config.system.nixos.release;
  };
}
