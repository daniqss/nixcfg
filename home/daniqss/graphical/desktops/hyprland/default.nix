{
  username,
  pkgs,
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./hypr
    ./rofi
    ./theming
    ./swww.nix
    ./waybar.nix
    ./mako.nix
  ];

  options.graphical.hyprland.enable = lib.mkEnableOption "Enable hyprland as desktop";

  config = lib.mkIf config.graphical.hyprland.enable {
    graphical.waybar.enable = lib.mkDefault false;
    graphical.rofi.enable = lib.mkDefault true;
    graphical.mako.enable = lib.mkDefault true;

    home.packages = with pkgs; [
      alsa-utils
      playerctl
      brightnessctl
      cliphist
      wl-clipboard
    ];

    home.sessionVariables = {
      HOME = "/home/${username}/";
      XDG_DESKTOP_DIR = "$HOME";
      XDG_DOCUMENTS_DIR = "$HOME/documents";
      XDG_DOWNLOAD_DIR = "$HOME/downloads";
      XDG_MUSIC_DIR = "$HOME/music";
      XDG_PICTURES_DIR = "$HOME/pictures";
      XDG_SCREENSHOTS_DIR = "$HOME/screenshots";
      XDG_VIDEOS_DIR = "$HOME/videos";
    };
  };
}
