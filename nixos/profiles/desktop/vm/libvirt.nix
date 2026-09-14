{
  username,
  pkgs,
  lib,
  config,
  ...
}: {
  options.desktop.vm.libvirt.enable = lib.mkEnableOption "enable libvirt/kvm virtualisation";

  config = lib.mkIf config.desktop.vm.libvirt.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };

    programs.virt-manager.enable = true;
    environment.systemPackages = [pkgs.virtiofsd];

    users.users.${username}.extraGroups = ["libvirtd" "kvm" "input"];
  };
}
