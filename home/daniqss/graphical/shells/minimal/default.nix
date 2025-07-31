{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.graphical.shells;
  rofi = config.graphical.rofi.scripts;
in {
  imports = [
    ./rofi
    ./waybar.nix
    ./mako.nix
  ];

  config = lib.mkIf (cfg == "minimal") {
    graphical.shells.commands = {
      bar = pkgs.waybar;
      applauncher = rofi.applauncher;
      emoji = rofi.emoji;
      clipboard = rofi.clipboard;
      sound = rofi.sound;
      powermenu = rofi.powermenu;
      wallpaper = rofi.wallpaper;
      bluetooth = rofi.bluetooth;
    };
    graphical.waybar.enable = lib.mkDefault true;
    graphical.rofi.enable = lib.mkDefault true;
  };
}
