{
  username,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.graphical.shells.quickshell;
  storeDir = ./. + "/${cfg.configName}";
  liveDir = "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell/${cfg.configName}";
in {
  options.graphical.shells.quickshell = {
    enable = lib.mkEnableOption "enable quickshell as shell bar";

    configSource = lib.mkOption {
      type = lib.types.enum ["store" "symlink"];
      default = "store";
    };

    configName = lib.mkOption {
      type = lib.types.str;
      default = "mandra";
    };
  };

  config = lib.mkIf cfg.enable {
    # programs used in quickshell
    home.packages = with pkgs; [
      pwvucontrol
      bottom
      networkmanager
      libnotify
      kdePackages.qtdeclarative
    ];

    programs.quickshell = {
      enable = true;
      systemd.enable = true;

      package = pkgs.symlinkJoin {
        name = "quickshell-wrapped";
        paths = with pkgs; [
          quickshell

          kdePackages.qtimageformats
          kdePackages.kirigami.unwrapped

          adwaita-icon-theme
          material-symbols
          material-icons
        ];
        meta.mainProgram = pkgs.quickshell.meta.mainProgram;
      };

      activeConfig = cfg.configName;

      configs.${cfg.configName} =
        if cfg.configSource == "store"
        then storeDir
        else config.lib.file.mkOutOfStoreSymlink liveDir;
    };

    home.sessionVariables = {
      QMLLS_BUILD_DIRS = "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/";
      QML_IMPORT_PATH = liveDir;
      QML2_IMPORT_PATH = "$QML2_IMPORT_PATH:${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/";
    };
  };
}
