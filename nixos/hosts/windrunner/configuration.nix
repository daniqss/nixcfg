{
  username,
  pkgs,
  ...
}: {
  config = {
    common.tailscale = {
      enable = true;
      role = "client";
    };
    desktop.enable = true;
    server.enable = false;

    hardware.graphics = {
      enable = true;
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.consoleMode = "max";
    boot.loader.efi.canTouchEfiVariables = true;

    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver.xkb = {
      layout = "es";
      variant = "";
    };

    virtualisation.virtualbox = {
      host.enable = true;
      guest.enable = true;
      guest.dragAndDrop = true;
    };
    users.extraGroups.vboxusers.members = ["${username}"];

    system.stateVersion = "25.05";
  };
}
