{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
in {
  imports = [
    ./minecraft.nix
    ./hollowknight.nix
  ];

  options.graphical.gaming.enable = mkEnableOption "enable gaming packages session";

  config = mkIf config.graphical.gaming.enable {
    graphical.gaming = {
      minecraft.enable = mkDefault true;
      hollowknight.enable = mkDefault false;
    };

    home.packages = with pkgs; [
      # tetris clon
      apotris
    ];
  };
}
