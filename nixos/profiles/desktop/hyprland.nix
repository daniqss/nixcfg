{
  username,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg' = config.home-manager.users.${username};
in {
  config = mkIf cfg'.graphical.desktops.hyprland.enable {
    environment.variables.NIXOS_OZONE_WL = "1";

    # hyprlock falls back to /etc/pam.d/su without its own pam service
    security.pam.services.hyprlock = {};

    programs.hyprland = {
      enable = true;

      # package = inputs.hyprnix.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # portalPackage = inputs.hyprnix.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    # to get gnome desktop portal working alongside hyprland's I needed to use nixcfg/home/daniqss/graphical/desktops/hyprland/hypr/portals.nix
    xdg.portal = {
      enable = true;
      config.hyprland = {
        default = ["hyprland"];
        "org.freedesktop.impl.portal.FileChooser" = ["gnome"];
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
      ];
    };
  };
}
