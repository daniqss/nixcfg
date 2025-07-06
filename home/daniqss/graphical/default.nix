{
  username,
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

    home.sessionVariables = {
      HOME = "/home/${username}/";
      XDG_DESKTOP_DIR = "$HOME";
      XDG_DOCUMENTS_DIR = "$HOME/Documents";
      XDG_DOWNLOAD_DIR = "$HOME/Downloads";
      XDG_PICTURES_DIR = "$HOME/Pictures";
      XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
      XDG_VIDEOS_DIR = "$HOME/Videos";
    };
  };
}
