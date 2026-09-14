{
  username,
  config,
  lib,
  ...
}: {
  options.desktop.vm.podman.enable = lib.mkEnableOption "enable podman";

  config = lib.mkIf config.desktop.vm.podman.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    users.users.${username}.extraGroups = ["podman"];
  };
}
