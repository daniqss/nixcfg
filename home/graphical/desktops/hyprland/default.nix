{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./hypr
    ./swww.nix
    ./rofi.nix
    ./waybar.nix
  ];

  options.graphical.hyprland.enable = lib.mkEnableOption "Enable hyprland as desktop";

  config = lib.mkIf config.graphical.hyprland.enable {
    graphical.hyprland.waybar.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      swww
      alsa-utils
      playerctl
      brightnessctl
      rofi-wayland
    ];
  };
}
