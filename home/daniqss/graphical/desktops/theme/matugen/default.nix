{
  inputs,
  system,
  username,
  pkgs,
  lib,
  config,
  ...
}: let
  wallpaper = "/home/${username}/nixcfg/assets/wallpapers/current";
  createMatugen = pkgs.writeShellScriptBin "createMatugen" ''
    echo "creating matugen theme..."
    ${lib.getExe' inputs.matugen.packages.${system}.default "matugen"} image ${wallpaper}
  '';
in {
  imports = [
    inputs.matugen.nixosModules.default
  ];

  config = lib.mkIf (config.graphical.desktops.desktop == "hyprland") {
    home.packages = [
      inputs.matugen.packages.${system}.default
      createMatugen
    ];

    programs.matugen.enable = true;
    services.swww.enable = true;

    home.file."${config.xdg.configHome}/matugen/templates".source = ./templates;
    home.file."${config.xdg.configHome}/matugen/config.toml".source = ./config.toml;
  };
}
