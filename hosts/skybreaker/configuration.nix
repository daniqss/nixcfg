{
  config,
  pkgs,
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
        emulatedSystems = ["armv6l-linux"];
      };
      gpg.enable = true;
      syncthing.enable = false;
    };
    desktop = {
      enable = true;

      virtualbox = {
        enable = false;
        guest.enable = false;
      };

      switch.enable = true;
    };
    server.enable = false;

    hardware.graphics = {
      enable = true;
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.consoleMode = "auto";
    boot.loader.efi.canTouchEfiVariables = true;

    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver.xkb = {
      layout = "es";
      variant = "";
    };

    # allows the build in keyboard to wake from suspend
    # services.udev.extraRules = ''
    # ACTION=="add|change", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="enabled"
    # '';

    system.stateVersion = config.system.nixos.release;
  };
}
