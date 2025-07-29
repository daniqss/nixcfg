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
    ./theme
    ./waybar.nix
    ./mako.nix
  ];

  options.graphical.hyprland.enable = lib.mkEnableOption "enable hyprland as desktop";
  options.graphical.uwsm.enable = lib.mkEnableOption "enable uwsm as session manager";

  config = lib.mkIf config.graphical.hyprland.enable {
    graphical.waybar.enable = lib.mkDefault false;
    graphical.rofi.enable = lib.mkDefault true;
    graphical.mako.enable = lib.mkDefault true;
    graphical.uwsm.enable = lib.mkDefault true;

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
