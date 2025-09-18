{
  username,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

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

  programs.adb.enable = true;

  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [username];
  # usb forwarding
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  environment.systemPackages = with pkgs; [vagrant];

  system.stateVersion = "25.05";
}
