{
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./desktops/hyprland
    ./emulators
  ];

  options.graphical.enable = lib.mkEnableOption "Enable graphical session";

  config = lib.mkIf config.graphical.enable {
    graphical.hyprland.enable = lib.mkDefault true;
  };
}
