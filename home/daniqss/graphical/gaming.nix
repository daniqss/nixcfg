{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./minecraft.nix
  ];

  options.graphical.gaming.enable = lib.mkEnableOption "enable gaming packages session";

  config = lib.mkIf (config.graphical.enable
    && config.graphical.gaming.enable) {
    home.packages = with pkgs; [
      # hollow knight mod manager
      pkgs.scarab

      # tetris clon
      apotris
    ];
  };
}
