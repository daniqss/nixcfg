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
    ./rofi
    ./waybar.nix
  ];

  options.graphical.hyprland.enable = lib.mkEnableOption "Enable hyprland as desktop";

  config = lib.mkIf config.graphical.hyprland.enable {
    graphical.waybar.enable = lib.mkDefault false;
    graphical.rofi.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      swww
      alsa-utils
      playerctl
      brightnessctl
      cliphist
      wl-clipboard
    ];
  };
}
