{
  username,
  pkgs,
  lib,
  config,
  ...
}: {
  options.graphical.shells.quickshell.enable = lib.mkEnableOption "enable quickshell as shell bar";

  config = lib.mkIf config.graphical.shells.quickshell.enable {
    graphical.shells.mako.enable = lib.mkDefault true;

    # programs used in quickshell
    home.packages = with pkgs; [
      pwvucontrol
      bottom
      networkmanager
      libnotify
    ];

    programs.quickshell = {
      enable = true;
      systemd.enable = true;

      package = pkgs.symlinkJoin {
        name = "quickshell-wrapped";
        paths = with pkgs; [
          quickshell

          adwaita-icon-theme
          material-symbols
          material-icons
        ];
        meta.mainProgram = pkgs.quickshell.meta.mainProgram;
      };

      activeConfig = "mandra";
    };

    home.sessionVariables = {
      HOME = "/home/${username}/";
      QMLLS_BUILD_DIRS = "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/";
      QML_IMPORT_PATH = "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell/mandra";
      QML2_IMPORT_PATH = "$QML2_IMPORT_PATH:${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/";
    };

    xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell";
  };
}
