{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  config = lib.mkIf config.graphical.enable {
    home.packages = with pkgs; [
      gtk3
    ];

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    gtk = {
      enable = true;

      theme = {
        name = "Orchis-Purple-Dark";
        package = pkgs.orchis-theme;
      };

      iconTheme = {
        name = "adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };
  };
}
