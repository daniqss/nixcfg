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
  config = mkIf (cfg'.graphical.desktops.desktop == "hyprland") {
    environment.variables.NIXOS_OZONE_WL = "1";

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
