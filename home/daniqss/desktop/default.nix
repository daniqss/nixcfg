{
  lib,
  config,
  ...
}: let
in {
  options.desktop.enable = lib.mkEnableOption "Enable graphical session";

  config = lib.mkIf config.desktop.enable {
    hyprland.enable = lib.mkDefault true;

    imports = [
      ./hyprland
    ];
  };
}
