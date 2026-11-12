{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    common = {
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

    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      powerManagement.enable = true;
      open = true;
    };
    boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";

      # gsync/vrr for opengl games (minecraft)
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
      # cap proton games (dx9-11 and dx12) 3 fps under 144hz, so they stay inside the vrr range
      DXVK_FRAME_RATE = "141";
      VKD3D_FRAME_RATE = "141";
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;

    # lanzaboote needs to force false, nevertheless it use systemd-boot under the hood
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.loader.systemd-boot.consoleMode = "max";
    # just in case
    boot.loader.systemd-boot.configurationLimit = 5;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    system.stateVersion = config.system.nixos.release;
  };
}
