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

      open = true;
      nvidiaSettings = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # broken motherboard (or wifi card, I guess is the motherboard), generates a AER error storm that consume cpu and fill the journal
    # disabling ASPM on the bus (setpci via udev) is not enough because the driver reenables it on probe
    # setting  the rtl8188ee driver own aspm parameter stops it
    boot.extraModprobeConfig = "options rtl8188ee aspm=0";

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
