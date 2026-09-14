{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  options.graphical.flatpak.enable = lib.mkOption {
    type = lib.types.bool;
    # nixos turns flatpak on system-wide, other distro may not have it installed
    default = config.platform.isNixOS;
    description = "manage flatpak packages from home-manager";
  };

  config.services.flatpak = lib.mkIf (!config.graphical.flatpak.enable) {
    enable = false;
    packages = [];
  };
}
