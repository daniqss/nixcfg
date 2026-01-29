{username, ...}: {
  boot.kernelParams = ["kvm.enable_virt_at_load=0"];
  virtualisation.virtualbox = {
    host = {
      enable = true;
      # enableExtensionPack = true;
    };

    guest = {
      enable = true;
      dragAndDrop = true;
    };
  };
  users.extraGroups.vboxusers.members = ["${username}"];
}
