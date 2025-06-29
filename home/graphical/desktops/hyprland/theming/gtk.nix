{pkgs, ...}: let
  orchisPkg = pkgs.orchis-theme.override {tweaks = ["black"];};
in {
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
      package = orchisPkg;
      name = "Orchis-Purple";
    };

    iconTheme = {
      package = orchisPkg;
      name = "Orchis-Purple";
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
}
