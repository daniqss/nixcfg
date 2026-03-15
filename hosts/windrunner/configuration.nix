{pkgs, ...}: {
  config = {
    common.tailscale = {
      enable = true;
      role = "client";
    };
    desktop = {
      enable = true;

      virtualbox.enable = true;
    };
    server.enable = false;

    hardware.graphics = {
      enable = true;
    };

    boot.kernelPackages = pkgs.linuxPackages_6_18;
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.consoleMode = "max";
    boot.loader.efi.canTouchEfiVariables = true;

    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver.xkb = {
      layout = "es";
      variant = "";
    };

    system.stateVersion = "25.05";
  };
}
