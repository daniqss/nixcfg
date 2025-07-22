{
  system,
  username,
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
        withHyprland = config.graphical.hyprland.enable;
        withI3 = false;
      })
      qt6.qtimageformats
      qt6.qt5compat
      qt6.qtmultimedia
      qt6.qtdeclarative
      material-symbols
    ];

    xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/nixcfg/home/daniqss/graphical/shells/quickshell";
  };
}
