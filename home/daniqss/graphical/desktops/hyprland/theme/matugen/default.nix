{
  inputs,
  username,
  system,
  pkgs,
  lib,
  config,
  ...
}: let
  wallpaper = "/home/${username}/nixcfg/assets/wallpapers/hill.gif";
  createMatugen = pkgs.writeShellScriptBin "createMatugen" ''
    echo "creating matugen theme..."
    ${lib.getExe' inputs.matugen.packages.${system}.default "matugen"} image ${wallpaper}
  '';
in {
  imports = [
    inputs.matugen.nixosModules.default
  ];

  config = lib.mkIf config.graphical.hyprland.enable {
    home.packages = [
      inputs.matugen.packages.${system}.default
      pkgs.swww
      createMatugen
    ];

    programs.matugen = {
      enable = true;
      variant = "dark";
      # jsonFormat = "hex";
      wallpaper = wallpaper;
    };

    home.file."${config.xdg.configHome}/matugen/templates".source = ./templates;
    home.file."${config.xdg.configHome}/matugen/config.toml".source = ./config.toml;

    home.activation.miScript = lib.hm.dag.entryAfter ["writeBoundary"] (lib.getExe createMatugen);

    wayland.windowManager.hyprland.settings.exec-once = [
      "${pkgs.swww}/bin/swww-daemon && sleep 1 && ${lib.getExe createMatugen}"
    ];
  };
}
