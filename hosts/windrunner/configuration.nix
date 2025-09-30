{
  username,
  pkgs,
  pkgs-stable,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/desktop.nix
    ../common/gaming.nix
    ../common/minecraft.nix
    ../common/network.nix
    ../common/nix.nix
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

  boot.kernelParams = ["kvm.enable_virt_at_load=0"];
  virtualisation.virtualbox.host = {
    enable = true;
    package = pkgs-stable.virtualbox;
  };
  users.extraGroups.vboxusers.members = [username];
  # usb forwarding
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  environment.systemPackages =
    (with pkgs-stable; [
      vagrant
      htop
    ])
    ++ (with pkgs; [
      bottom
      nitch
    ]);

  system.stateVersion = "25.05";
}
