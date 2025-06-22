{
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./hyprland
  ];

  options.desktop.enable = lib.mkEnableOption "Enable graphical session";

  config = lib.mkIf config.desktop.enable {
    hyprland.enable = lib.mkDefault true;
  };
}
