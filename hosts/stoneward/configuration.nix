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
      qemu = {
        enable = true;
        emulatedSystems = ["armv6l-linux" "aarch64-linux"];
      };
      syncthing.enable = false;
    };
    desktop.enable = true;
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
    # these rules use setpci to disable ASPM on the wifi card and the pcie bridge that connects it, fixing the issue
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:1c.4", RUN+="${pkgs.pciutils}/bin/setpci -s 00:1c.4 CAP_EXP+10.b=0:3"
      ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:05:00.0", RUN+="${pkgs.pciutils}/bin/setpci -s 05:00.0 CAP_EXP+10.b=0:3"
    '';

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
