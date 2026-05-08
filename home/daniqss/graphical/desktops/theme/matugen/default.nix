{
  username,
  pkgs,
  lib,
  config,
  ...
}: let
  wallpaper = "/home/${username}/nixcfg/assets/wallpapers/current";
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

    services.swww.enable = true;

    home.file."${config.xdg.configHome}/matugen/templates".source = ./templates;
    home.file."${config.xdg.configHome}/matugen/config.toml".source = ./config.toml;
  };
}
