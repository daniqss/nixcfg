{
  config,
  pkgs,
  ...
}: {
  config = {
    common = {
      tailscale.enable = false;
      syncthing.enable = false;
    };

    desktop = {
      enable = true;
      kde.enable = true;
      gaming.enable = false;
    };
    server.enable = false;

    hardware.graphics.enable = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.consoleMode = "auto";
    boot.loader.efi.canTouchEfiVariables = true;

    services.printing.enable = true;
    services.printing.drivers = [pkgs.cups-filters];

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    i18n.defaultLocale = "es_ES.UTF-8";

    services.xserver.xkb = {
      layout = "es";
      variant = "";
    };

    system.stateVersion = config.system.nixos.release;
  };
}
