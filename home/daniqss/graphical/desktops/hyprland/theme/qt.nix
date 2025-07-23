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
  '';
in {
  config = lib.mkIf config.graphical.enable {
    home.packages = with pkgs; [
      libsForQt5.qt5ct
      qt6ct
    ];

    qt = {
      enable = true;
      platformTheme.name = "qt6ct";
    };

    home.file.".config/qt5ct/qt5ct.conf".text = qtConfig "5";
    home.file.".config/qt6ct/qt6ct.conf".text = qtConfig "6";
  };
}
