{
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./hyprland
    ./ghostty.nix
  ];

  options.desktop = {
    enable = lib.mkEnableOption "Enable graphical session";
    hyprland.enable = lib.mkEnableOption "Enable Hyprland window manager";
  };

  config = lib.mkIf config.desktop.enable {
    hyprland.enable = lib.mkIf config.desktop.hyprland.enable true;
  };
}
