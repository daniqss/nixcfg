{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  config = lib.mkIf config.graphical.hyprland.enable {
    home.packages = [
      pkgs.swww
      # set-random-wallpaper
      # init-swww-with-wallpaper
      # wallpaper-randomizer
    ];

    wayland.windowManager.hyprland.settings.exec-once = [
      "${pkgs.swww}/bin/swww-daemon && ${pkgs.swww}/bin/swww img /home/daniqss/image8.png}"
    ];
  };
}
