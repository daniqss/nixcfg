{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.graphical.gaming.hollowknight.enable = mkEnableOption "enable packages for hollow knight no hit";

  config = mkIf config.graphical.gaming.hollowknight.enable {
    home.packages = with pkgs; [
      # hollow knight mod manager
      lumafly
      obs-studio
      hitcountermanager
    ];
  };
}
