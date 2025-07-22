{
  inputs,
  system,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.matugen.nixosModules.default
  ];

  home.packages = lib.mkIf config.graphical.enable [
    inputs.matugen.packages.${system}.default
  ];

  programs.matugen = {
    enable = true;
    variant = "dark";
    jsonFormat = "hex";
    wallpaper = ../../../../../../../assets/wallpapers/arch.png;
  };

  home.file."${config.xdg.configHome}/matugen/templates".source = ./templates;
  home.file."${config.xdg.configHome}/matugen/config.toml".source = ./config.toml;
  home.file."Pictures/wallpapers".source = ../../../../../../../assets/wallpapers;
}
