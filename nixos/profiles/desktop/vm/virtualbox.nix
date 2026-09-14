{
  username,
  lib,
  config,
  ...
}: {
  options.desktop.vm.virtualbox = {
    enable = lib.mkEnableOption "enable virtualbox support";
    guest.enable = lib.mkEnableOption "enable virtualbox support";
  };

  config = lib.mkIf config.desktop.vm.virtualbox.enable {
    boot.kernelParams = ["kvm.enable_virt_at_load=0"];
    virtualisation.virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };

      guest = lib.mkIf config.desktop.vm.virtualbox.guest.enable {
        enable = true;
        dragAndDrop = true;
        clipboard = true;
      };
    };

    users.extraGroups.vboxusers.members = ["${username}"];
  };
}
