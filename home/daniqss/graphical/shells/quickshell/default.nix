{
  username,
  pkgs,
  lib,
  config,
  ...
}: {
  options.graphical.shells.quickshell = {
    enable = lib.mkEnableOption "enable quickshell as shell bar";
    systemd = {
      enable = lib.mkEnableOption "quickshell systemd integration";

      autoStart = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "whether to auto start quickshell service";
      };
    };
  };

  config = lib.mkIf config.graphical.shells.quickshell.enable {
    graphical.shells.mako.enable = lib.mkDefault true;

    graphical.shells.quickshell.systemd.enable = lib.mkDefault true;

    # quickshell config
    home.packages = with pkgs; [
      quickshell
      kdePackages.qtdeclarative
      qt6.qtimageformats
      qt6.qt5compat
      qt6.qtmultimedia
      qt6.qtdeclarative
      material-symbols

      # programs used in quickshell
      pwvucontrol
      bottom
      networkmanager #nmtui and nmcli
      libnotify
    ];

    home.sessionVariables = {
      HOME = "/home/${username}/";
      QMLLS_BUILD_DIRS = "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/";
      QML_IMPORT_PATH = "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell/mandra";
      QML2_IMPORT_PATH = "$QML2_IMPORT_PATH:${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/";
    };

    xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell";

    systemd.user.services.quickshell = lib.mkIf config.graphical.shells.quickshell.systemd.enable {
      Unit = {
        Description = "start quickshell bar";
        After = "hyprland-session.target";
      };
      Service = {
        ExecStart = "${lib.getExe' pkgs.quickshell "quickshell"} -c mandra";
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install.WantedBy = ["hyprland-session.target"];
    };
  };
}
