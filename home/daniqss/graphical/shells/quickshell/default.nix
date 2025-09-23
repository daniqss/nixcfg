{
  system,
  username,
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.graphical.shells;
  rofi = config.graphical.rofi.scripts;

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
    home.packages = [
      quickshellPkg
      pkgs.kdePackages.qtdeclarative
      pkgs.qt6.qtimageformats
      pkgs.qt6.qt5compat
      pkgs.qt6.qtmultimedia
      pkgs.qt6.qtdeclarative

      pkgs.material-symbols

      # programs used in quickshell
      pkgs.pwvucontrol
      pkgs.bottom
      pkgs.networkmanager #nmtui and nmcli
    ];

    home.sessionVariables = {
      HOME = "/home/${username}/";
      QMLLS_BUILD_DIRS = "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${quickshellPkg}/lib/qt-6/qml/";
      QML_IMPORT_PATH = "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell/mandra";
      QML2_IMPORT_PATH = "$QML2_IMPORT_PATH:${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${quickshellPkg}/lib/qt-6/qml/";
    };

    xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell";
  };
}
