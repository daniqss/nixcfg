{
  username,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.home-manager.users.${username};
in {
  config = lib.mkIf (cfg.graphical.desktops.desktop == "hyprland") {
    programs.hyprland = {
      enable = true;
      withUWSM = cfg.graphical.desktops.uwsm.enable;
    };

    xdg.portal = {
      enable = true;
      config.hyprland = {
        default = ["hyprland"];
        "org.freedesktop.impl.portal.FileChooser" = ["gnome"];
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-hyprland
      ];
    };
  };
}
