{
  inputs,
  username,
  config,
  lib,
  ...
}: let
  cfg = config.home-manager.users.${username};
in {
  imports = [
    inputs.pinnacle.nixosModules.default
  ];

  config = lib.mkIf (cfg.graphical.desktops.desktop == "pinnacle") {
    programs.pinnacle = {
      enable = true;
      xdg-portals.enable = true;
    };
  };
}
