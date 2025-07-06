{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./hypr
    ./rofi
    ./theming
    ./swww.nix
    ./waybar.nix
    ./mako.nix
  ];

  options.graphical.hyprland.enable = lib.mkEnableOption "enable hyprland as desktop";

  config = lib.mkIf config.graphical.hyprland.enable {
    graphical.waybar.enable = lib.mkDefault false;
    graphical.rofi.enable = lib.mkDefault true;
    graphical.mako.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      alsa-utils
      playerctl
      brightnessctl
      cliphist
      wl-clipboard
    ];

    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
