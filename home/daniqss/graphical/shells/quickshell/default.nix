{
  system,
  username,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  quickshellPkg = inputs.quickshell.packages.${system}.default.override {
    withJemalloc = true;
    withQtSvg = true;
    withWayland = true;
    withX11 = false;
    withPipewire = true;
    withPam = true;
    withHyprland = config.graphical.hyprland.enable;
    withI3 = false;
  };
in {
  options.graphical.quickshell.enable = lib.mkEnableOption "enable quickshell as desktop shell";

  config = lib.mkIf config.graphical.quickshell.enable {
    home.packages = [
      quickshellPkg
      pkgs.kdePackages.qtdeclarative
      pkgs.qt6.qtimageformats
      pkgs.qt6.qt5compat
      pkgs.qt6.qtmultimedia
      pkgs.qt6.qtdeclarative
      pkgs.material-symbols
    ];

    home.sessionVariables = {
      HOME = "/home/${username}/";
      QMLLS_BUILD_DIRS = "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${quickshellPkg}/lib/qt-6/qml/";
      QML_IMPORT_PATH = "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell";
    };

    xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell";
  };
}
