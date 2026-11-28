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
      binfmt = {
        enable = true;
        emulatedSystems = ["armv6l-linux"];
      };
      syncthing.enable = false;
    };
    desktop = {
      enable = true;

      vm = {
        podman.enable = true;
        libvirt.enable = true;

        virtualbox = {
          enable = true;
          guest.enable = true;
        };
      };
    };
    server.enable = false;

    hardware.graphics = {
      enable = true;
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;

    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver.xkb = {
      layout = "es";
      variant = "";
    };

    system.stateVersion = config.system.nixos.release;
  };
}
