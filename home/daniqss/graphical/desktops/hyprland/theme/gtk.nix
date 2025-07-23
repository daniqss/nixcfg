{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
in {
  config = lib.mkIf config.graphical.enable {
    home.packages = [
      pkgs.morewaita-icon-theme
      inputs.self.packages.${pkgs.system}.adwaita-colors
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

      iconTheme = {
        name = "MoreWaita";
        package = pkgs.morewaita-icon-theme;
      };

      gtk2.extraConfig = ''
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';

      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintslight";
          gtk-xft-rgba = "rgb";
          gtk-decoration-layout = "menu:";
        };
        extraCss = "@import 'colors.css';";
      };

      gtk4 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = 1;
          gtk-decoration-layout = "menu:";
        };
        extraCss = "@import 'colors.css';";
      };
    };
  };
}
