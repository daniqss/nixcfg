{
  pkgs,
  lib,
  config,
  ...
}: let
  applauncher = pkgs.writeShellScriptBin "applauncher" "${pkgs.rofi-wayland}/bin/rofi -config $HOME/.config/rofi/config.rasi -show drun";
  emoji = pkgs.writeShellScriptBin "emoji" "rofi -modi emoji -show emoji";
  clipboard = pkgs.writeShellScriptBin "clipboard" "cliphist list | rofi -dmenu | cliphist decode | wl-copy";
  sound = pkgs.writeShellScriptBin "sound" (builtins.readFile ./sound.sh);
  powermenu = pkgs.writeShellScriptBin "powermenu" (builtins.readFile ./powermenu.sh);
  wallpaper = pkgs.writeShellScriptBin "wallpaper" (builtins.readFile ./wallpaper.sh);
  bluetooth = pkgs.writeShellScriptBin "bluetooth" (builtins.readFile ./bluetooth.sh);
in {
  options.graphical.rofi.enable = lib.mkEnableOption "enable rofi as launcher";
  options.graphical.rofi.scripts = lib.mkOption {
    type = lib.types.attrsOf lib.types.package;
    description = "Custom Rofi scripts";
  };

  config = lib.mkIf config.graphical.rofi.enable {
    graphical.rofi.scripts = {
      inherit applauncher emoji clipboard sound powermenu wallpaper bluetooth;
    };

    home.packages = [
      pkgs.jq
      pkgs.libnotify

      applauncher
      emoji
      clipboard
      sound
      powermenu
      wallpaper
      bluetooth
    ];

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.ghostty}/bin/ghostty";
      theme = ./colors.rasi;
      extraConfig = {
        show-icons = true;
        drun-icon-theme = "Windows 10";
        font = "CaskaydiaCove Nerd Font 10";
        display-run = "󱓞 run:";
        display-drun = "󱓞 drun:";
        display-window = "󱂬 window:";
        display-combi = "󰕘 combi:";
        display-filebrowser = "󰉋 filebrowser:";
        dpi = 110;
      };

      plugins = with pkgs; [
        rofi-emoji-wayland
      ];
    };
  };
}
