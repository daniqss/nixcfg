{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
in {
  imports = [
    ./hypr
    ./theme
  ];

  options.graphical.hyprland.enable = mkEnableOption "enable hyprland as desktop";
  options.graphical.hyprland.hyprqtile.enable = mkEnableOption "enable hyprqtile as workspace switcher";

  options.graphical.uwsm.enable = mkEnableOption "enable uwsm as session manager";

  config = mkIf config.graphical.hyprland.enable {
    graphical.uwsm.enable = mkDefault true;
    graphical.hyprland.hyprqtile.enable = mkDefault false;
    graphical.shells.shell = mkDefault "quickshell";

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
