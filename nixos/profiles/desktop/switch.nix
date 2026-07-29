{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.desktop.switch;
in {
  options.desktop.switch.enable = lib.mkEnableOption "enable switch homebrew tooling";
  options.desktop.switch.nsusbloader.enable = lib.mkEnableOption "enable ns-usbloader for switch homebrew tooling";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      desktop.switch.nsusbloader.enable = lib.mkDefault true;

      environment.systemPackages = with pkgs; [
        fusee-nano
      ];
    })

    (lib.mkIf cfg.nsusbloader.enable {
      environment.systemPackages = with pkgs; [
        ns-usbloader
      ];

      # switch connects back on this port using NET
      networking.firewall.interfaces.wlp0s20f3.allowedTCPPorts = [6042];

      # udev rules to use usb
      services.udev.packages = [
        (pkgs.writeTextFile {
          name = "ns-usbloader-udev-rules";
          destination = "/etc/udev/rules.d/70-ns-usbloader.rules";
          text = ''
            SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", TAG+="uaccess"
          '';
        })
      ];
    })
  ];
}
