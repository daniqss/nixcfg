{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  config = lib.mkIf config.graphical.enable {
    home.packages = [
      pkgs.morewaita-icon-theme
      pkgs.adwaita-colors
    ];

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    gtk = {
      enable = true;

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      gtk2.extraConfig = ''
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';

      gtk3 = {
        theme = {
          package = pkgs.adw-gtk3;
          name = "adw-gtk3-dark";
        };
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
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
        extraConfig = {
          gtk-decoration-layout = "menu:";
        };
        extraCss = "@import 'colors.css';";
      };
    };
  };
}
