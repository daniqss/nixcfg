{
  flakeDir,
  pkgs,
  lib,
  config,
  ...
}: let
  wallpaper = "${flakeDir}/assets/wallpapers/current";
  createMatugen = pkgs.writeShellScriptBin "createMatugen" ''
    echo "creating matugen theme..."
    ${lib.getExe pkgs.matugen} image ${wallpaper}
  '';
in {
  config = lib.mkIf (config.graphical.desktops.desktop == "hyprland") {
    home.packages = [
      pkgs.matugen
      createMatugen
    ];

    services.awww.enable = true;

    home.file."${config.xdg.configHome}/matugen/templates".source = ./templates;
    home.file."${config.xdg.configHome}/matugen/config.toml".source = ./config.toml;
  };
}
