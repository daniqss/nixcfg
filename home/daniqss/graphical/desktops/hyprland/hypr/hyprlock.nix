{
  lib,
  config,
  ...
}: let
in {
  config = lib.mkIf config.graphical.hyprland.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        background = {
          monitor = "";
          path = "$HOME/image8.png";
          blur_passes = 1;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        };

        general = {
          hide_cursor = true;
          grace = 0;
          disable_loading_bar = false;
        };

        input-field = {
          monitor = "";
          size = [250 60];
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(0, 0, 0, 0.5)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          placeholder_text = ''<i><span foreground="##cdd6f4">Type to Unlock!</span></i>'';
          hide_input = false;
          position = "0, -120";
          halign = "center";
          valign = "center";
        };

        label = [
          # TIME
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +"%-I:%M%p")"'';
            color = "rgba(255, 255, 255, 0.6)";
            font_size = 120;
            font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
            position = "0, -300";
            halign = "center";
            valign = "top";
          }

          # USER
          {
            monitor = "";
            text = "Hi there, $USER";
            color = "rgba(255, 255, 255, 0.6)";
            font_size = 25;
            font_family = "JetBrains Mono Nerd Font Mono";
            position = "0, -40";
            halign = "center";
            valign = "center";
          }

          # # CURRENT SONG
          # {
          #   monitor = "";
          #   text = ''cmd[update:1000] echo "$(~/.config/scripts/what_song.sh)"'';
          #   color = "rgba(255, 255, 255, 0.6)";
          #   font_size = 18;
          #   font_family = "JetBrainsMono, Font Awesome 6 Free Solid";
          #   position = "0, 5";
          #   halign = "center";
          #   valign = "bottom";
          # }

          # DATE
          {
            monitor = "";
            text = ''cmd[update:1000] echo "$(date +'%d %b,%A')"'';
            color = "rgba(255, 255, 255, 0.6)";
            font_size = 15;
            font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
            position = "0, -10";
            halign = "center";
            valign = "top";
          }
        ];
      };
    };
  };
}
