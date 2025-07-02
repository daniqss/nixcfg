{
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./desktops/hyprland
    ./emulators
    ./misc.nix
  ];

  options.graphical.enable = lib.mkEnableOption "Enable graphical session";
  options.graphical.gaming.enable = lib.mkEnableOption "enable gaming";

  config = lib.mkIf config.graphical.enable {
    graphical.hyprland.enable = lib.mkDefault true;
  };
}
