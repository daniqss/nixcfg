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

  options.graphical = {
    enable = lib.mkEnableOption "Enable graphical session";
    hyprland.enable = lib.mkEnableOption "Enable hyprland as desktop";
  };

  config = lib.mkIf config.graphical.enable {
    graphical.hyprland.enable = lib.mkDefault true;
  };
}
