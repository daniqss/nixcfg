{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.graphical.desktops.hyprland.enable {
    services.hyprpolkitagent = {
      enable = true;
      package = pkgs.hyprpolkitagent;
    };
  };
}
