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

    hardware.graphics = {
      enable = true;
    };

    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
      modesetting.enable = true;

      powerManagement.enable = true;
      powerManagement.finegrained = false;

      open = false;
      nvidiaSettings = false;
      # keep the driver loaded so the clock lock is not reset
      nvidiaPersistenced = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    boot.extraModprobeConfig = "options nvidia NVreg_EnableGpuFirmware=0";

    # underclock to try to unfock my beloved gtx 1660 gpu
    # core locked to 300-1500 MHz, power capped at 100 W (stock 130 W) and memory
    services.lact = {
      enable = true;
      settings = {
        version = 7;
        daemon = {
          log_level = "info";
          admin_group = "wheel";
          disable_clocks_cleanup = false;
        };
        apply_settings_timer = 5;
        gpus."10DE:2184-1458:3FC8-0000:01:00.0" = {
          power_cap = 100.0;
          min_core_clock = 300;
          max_core_clock = 1500;
          mem_clock_offsets."0" = -500;
        };
      };
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
