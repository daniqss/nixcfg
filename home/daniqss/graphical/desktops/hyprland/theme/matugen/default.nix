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

    systemd.user.services = {
      startSwwwDaemon = {
        Unit = {
          Description = "starts swww daemon";
          After = "wayland-wm@Hyprland.service";
        };

        Install.WantedBy = ["default.target"];

        Service = {
          ExecStart = lib.getExe' pkgs.swww "swww-daemon";
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 3;
        };
      };

      createMatugen = {
        Unit = {
          Description = "starts swww daemon";
          After = "startSwwwDaemon.service";
        };

        Install.WantedBy = ["default.target"];
        Service = {
          ExecStart = lib.getExe createMatugen;
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 3;
        };
      };
    };
  };
}
