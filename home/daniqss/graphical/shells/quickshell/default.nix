{
  system,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options.graphical.quickshell.enable = lib.mkEnableOption "enable quickshell as desktop shell";

  config = lib.mkIf config.graphical.quickshell.enable {
    home.packages = with pkgs; [
      (inputs.quickshell.packages.${system}.default.override {
        withJemalloc = true;
        withQtSvg = true;
        withWayland = true;
        withX11 = false;
        withPipewire = true;
        withPam = true;
        withHyprland = true;
      })
      kdePackages.qtdeclarative
      kdePackages.qtbase
      kdePackages.qtdeclarative
    ];

    #     pkgs.mkShell {
    #   packages = [
    #     quickshell
    #     pkgs.kdePackages.qtdeclarative
    #   ];
    #   shellHook = ''
    #     # Required for qmlls to find the correct type declarations
    #     export QMLLS_BUILD_DIRS=${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${quickshell}/lib/qt-6/qml/
    #     export QML_IMPORT_PATH=$PWD/src
    #    '';
    # }
  };
}
