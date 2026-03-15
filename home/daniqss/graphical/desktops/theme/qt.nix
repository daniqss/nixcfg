{
  pkgs,
  lib,
  config,
  ...
}: let
  qtConfig = n: ''
    [Appearance]
    color_scheme_path=${config.xdg.configHome}/qt${n}ct/matugen.conf
    custom_palette=true

    [Fonts]
    fixed="CaskaydiaCove Nerd Font Mono,9,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"
    general="Cantarell,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,Regular"

    [Icon Theme]
    name=WhiteSur-dark
  '';
in {
  config = lib.mkIf config.graphical.enable {
    home.packages = with pkgs; [
      libsForQt5.qt5ct
      qt6Packages.qt6ct
      whitesur-kde
      whitesur-icon-theme
    ];

    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
    };

    home.file.".config/qt5ct/qt5ct.conf".text = qtConfig "5";
    home.file.".config/qt6ct/qt6ct.conf".text = qtConfig "6";
  };
}
