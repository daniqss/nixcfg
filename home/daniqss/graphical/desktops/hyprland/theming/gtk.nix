{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  config = lib.mkIf config.graphical.enable {
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    gtk = {
      enable = true;

      iconTheme = {
        name = "MoreWaita";
        package = pkgs.morewaita-icon-theme;
      };

      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk3.extraCss = "@import url(\"colors.css\");";
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraCss = "@import url(\"colors.css\");";
    };
  };
}
