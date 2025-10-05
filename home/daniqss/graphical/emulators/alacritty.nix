{
  lib,
  config,
  ...
}: let
  cfg = config.graphical.emulators;
in {
  config = (lib.mkIf cfg.emulator == "alacritty") {
    programs.alacritty = {
      enable = true;

      settings = {
        colors = {
          primary = {
            background = "#0A0A0A";
            foreground = "#bdb9ae";
          };

          normal = {
            black = "#15171c";
            red = "#ec5f67";
            green = "#80a763";
            yellow = "#fdc253";
            blue = "#5485c0";
            magenta = "#bf83c0";
            cyan = "#57c2c0";
            white = "#eeece7";
          };

          bright = {
            black = "#545454";
            red = "#ff6973";
            green = "#93d393";
            yellow = "#ffd156";
            blue = "#4d83d0";
            magenta = "#ff55ff";
            cyan = "#83e8e4";
            white = "#ffffff";
          };
        };

        cursor = {
          blink_interval = 5;
          thickness = 0.2;
          unfocused_hollow = true;
        };

        font = {
          size = 14.0;

          normal = {
            family = "CaskaydiaCove Nerd Font";
            style = "Regular";
          };

          bold = {
            family = "CaskaydiaCove Nerd Font";
            style = "Bold";
          };

          italic = {
            family = "CaskaydiaCove Nerd Font";
            style = "Italic";
          };

          bold_italic = {
            family = "CaskaydiaCove Nerd Font";
            style = "Bold Italic";
          };

          offset = {
            x = 0;
            y = 0;
          };
        };

        window = {
          padding = {
            x = 12;
            y = 5;
          };
          opacity = 0.9;
          dynamic_title = true;
        };
      };
    };
  };
}
