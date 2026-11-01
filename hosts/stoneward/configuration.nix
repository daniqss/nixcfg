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

    # if the gpu hangs again (Xid 119/1/154 in `journalctl -k`, GSP firmware crash),
    boot.extraModprobeConfig = "options nvidia NVreg_EnableGpuFirmware=0";

    # underclock to try to the focking gpu
    # core locked to 300-1700 MHz, memory offset for pstate 0 (check mclk with `nvidia-smi dmon -s pc`)
    # clock fields go directly under the gpu, lact flattens clocks_configuration
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
          min_core_clock = 300;
          max_core_clock = 1700;
          mem_clock_offsets."0" = -500; # transfer rate, mclk drops by half (-500 -> 3750 MHz). -1000 halts the gpu at boot (Xid 62)
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
