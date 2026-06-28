{
  username,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.home-manager.users.${username};
in {
  # fallback to `none` to avoid problems with users without that home manager option defined
  config = lib.mkIf ((cfg.graphical.desktops.desktop or "none") == "hyprland") {
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
