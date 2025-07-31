{
  username,
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./desktops/hyprland
    ./shells
    ./browsers
    ./emulators
    ./misc.nix
    ./gaming.nix
  ];

  options.graphical.enable = lib.mkEnableOption "Enable graphical session";

  config = lib.mkIf config.graphical.enable {
    graphical.hyprland.enable = lib.mkDefault true;
    graphical.browsers = {};

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
