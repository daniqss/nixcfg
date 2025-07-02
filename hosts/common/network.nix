{hostname, ...}: {
  networking.hostName = hostname;

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}
