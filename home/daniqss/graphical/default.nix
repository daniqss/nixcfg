{
  username,
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf mkEnableOption;
in {
  imports = [
    ./desktops
    ./shells
    ./browsers
    ./emulators
    ./misc
    ./gaming
    ./flatpak.nix
  ];

  options.graphical.enable = mkEnableOption "Enable graphical session";

  config = mkIf config.graphical.enable {
    graphical = {
      desktops.desktop = "hyprland";
      browsers = {
        enable = mkDefault true;
      };

      emulators = mkDefault {
        emulator = "ghostty";
        fontsize = 13;
      };

      misc = {
        enable = mkDefault true;
        personal.enable = mkDefault true;
        work.enable = mkDefault false;
      };

      gaming.enable = mkDefault true;
    };

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
