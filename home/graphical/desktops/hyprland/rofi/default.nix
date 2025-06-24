{
  pkgs,
  lib,
  config,
  ...
}: let
  # raw scripts
  clipboardScript = builtins.readFile ./clipboard.sh;
  soundScript = builtins.readFile ./sound.sh;

  # available rofi scripts
  applauncher = pkgs.writeShellScriptBin "applauncher" "${pkgs.rofi-wayland}/bin/rofi -config $HOME/.config/rofi/config.rasi -show drun";
  emoji = pkgs.writeShellScriptBin "emoji" " rofi -modi emoji -show emoji";
  # clipboard = pkgs.writeShellScriptBin ''
  #   clipboard" "rofi -modi clipboard:'rofi-cliphist' -show clipboard
  # '';
  # sound = pkgs.writeShellScriptBin "sound" ''
  #   rofi -show rofi-sound -modi 'rofi-sound:rofi-sound-output-chooser
  # '';
  powermenu = pkgs.writeShellScriptBin "powermenu" (builtins.readFile ./powermenu.sh);
  wallpaper = pkgs.writeShellScriptBin "wallpaper" (builtins.readFile ./wallpaper.sh);
  bluetooth = pkgs.writeShellScriptBin "bluetooth" (builtins.readFile ./bluetooth.sh);
in {
  options.graphical.rofi.enable = lib.mkEnableOption "enable rofi";

  config = lib.mkIf config.graphical.rofi.enable {
    home.packages = [
      applauncher
      emoji
      # clipboard
      # sound
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

    # home.file = {
    #   ".config/rofi/rofi-cliphist".text = clipboardScript;
    #   ".config/rofi/rofi-sound-output-chooser".text = soundScript;
    # };
  };
}
