{
  username,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.graphical.shells;
  rofi = config.graphical.rofi.scripts;
in {
  config = lib.mkIf (config.graphical.enable && (cfg.shell == "quickshell")) {
    # quickshell shells option config
    graphical.shells.commands = {
      bar = pkgs.writeShellScriptBin "bar" "qs -c mandra";
      notifications = pkgs.writeShellScriptBin "notifications" "${lib.getExe pkgs.mako}";
      applauncher = rofi.applauncher;
      emoji = rofi.emoji;
      clipboard = rofi.clipboard;
      sound = rofi.sound;
      powermenu = rofi.powermenu;
      wallpaper = rofi.wallpaper;
      bluetooth = rofi.bluetooth;
    };
    graphical.rofi.enable = lib.mkDefault true;
    graphical.mako.enable = lib.mkDefault true;

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
    ];

    home.sessionVariables = {
      HOME = "/home/${username}/";
      QMLLS_BUILD_DIRS = "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/";
      QML_IMPORT_PATH = "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell/mandra";
      QML2_IMPORT_PATH = "$QML2_IMPORT_PATH:${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${pkgs.quickshell}/lib/qt-6/qml/";
    };

    xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell";
  };
}
