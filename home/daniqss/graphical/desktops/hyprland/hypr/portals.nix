{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.graphical.hyprland.enable {
    xdg.portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        # xdg-desktop-portal-gnome
      ];
      #   config = {
      #     hyprland = {
      #       default = [
      #         "hyprland"
      #         "gnome"
      #       ];
      #       "org.freedesktop.impl.portal.FileChooser" = "gnome";
      #     };
      #   };
      # };
    };

    services.gnome-keyring = {
      enable = true;
    };
  };
}
