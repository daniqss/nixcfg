{
  pkgs,
  lib,
  config,
  ...
}: {
  services.hypridle = lib.mkIf (config.graphical.desktops.desktop == "hyprland") {
    enable = true;
    package = pkgs.unstable.hypridle;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on && checkSunsetOnStart";
      };

      listener = [
        {
          timeout = 500;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }

        {
          timeout = 500;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight";
        }

        {
          timeout = 800;
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        {
          timeout = 1200;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
