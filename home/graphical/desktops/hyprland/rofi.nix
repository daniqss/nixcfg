{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.graphical.hyprland.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
  };
}
