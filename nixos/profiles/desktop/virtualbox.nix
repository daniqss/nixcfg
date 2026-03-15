{
  username,
  lib,
  config,
  ...
}: {
  options.desktop.virtualbox.enable = lib.mkEnableOption "enable virtualbox support";
  options.desktop.virtualbox.guest.enable = lib.mkEnableOption "enable virtualbox support";

  config = lib.mkIf config.desktop.virtualbox.enable {
    boot.kernelParams = ["kvm.enable_virt_at_load=0"];
    virtualisation.virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };

      guest = lib.mkIf config.desktop.virtualbox.guest.enable {
        enable = true;
        dragAndDrop = true;
        clipboard = true;
      };
    };
    users.extraGroups.vboxusers.members = ["${username}"];
  };
}
