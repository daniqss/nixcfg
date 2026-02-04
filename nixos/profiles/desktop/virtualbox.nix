{
  username,
  lib,
  config,
  ...
}: {
  options.desktop.virtualbox.enable = lib.mkEnableOption "enable virtualbox support";

  config = lib.mkIf config.desktop.virtualbox.enable {
    boot.kernelParams = ["kvm.enable_virt_at_load=0"];
    virtualisation.virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };

      guest = {
        enable = true;
        dragAndDrop = true;
        clipboard = true;
      };
    };
    users.extraGroups.vboxusers.members = ["${username}"];
  };
}
