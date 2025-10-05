{
  lib,
  config,
  ...
}: {
  programs.ghostty = lib.mkIf config.graphical.enable {
    enable = true;
    enableZshIntegration = true;

    themes = {
      kinda-onedark = {
        background = "0A0A0A";
        foreground = "bdb9ae";
        cursor-color = "bdb9ae";
        selection-background = "15171c";
        selection-foreground = "eeece7";
        palette = [
          "0=#15171c"
          "1=#ec5f67"
          "2=#80a763"
          "3=#fdc253"
          "4=#5485c0"
          "5=#bf83c0"
          "6=#57c2c0"
          "7=#eeece7"
          "8=#545454"
          "9=#ff6973"
          "10=#93d393"
          "11=#ffd156"
          "12=#4d83d0"
          "13=#ff55ff"
          "14=#83e8e4"
          "15=#ffffff"
        ];
      };
    };
    settings = {
      theme = "kinda-onedark";
      background-opacity = 0.9;

      keybind = [
        "alt+t=new_tab"
        "alt+w=close_tab"
      ];

      font-family = "CaskaydiaCove Nerd Font Mono";
      font-size = config.graphical.emulators.fontsize;
      font-thicken = true;
      bold-is-bright = false;
      adjust-box-thickness = 1;

      cursor-style = "block";
      cursor-style-blink = false;

      window-padding-x = 8;
      window-padding-y = 5;
      window-padding-balance = true;
      window-padding-color = "background";
      window-inherit-working-directory = true;
      window-inherit-font-size = true;
      resize-overlay = "never";
      confirm-close-surface = false;
      mouse-hide-while-typing = true;
      clipboard-paste-protection = false;

      gtk-titlebar = true;
      gtk-single-instance = false;
      gtk-tabs-location = "top";
      gtk-wide-tabs = true;
      working-directory = "home";

      copy-on-select = true;
      auto-update = "off";
    };
  };
}
