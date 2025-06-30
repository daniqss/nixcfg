{
  lib,
  config,
  ...
}: {
  options.graphical.waybar.enable = lib.mkEnableOption "enable waybar as hyprland bar";

  config = lib.mkIf config.graphical.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          spacing = 0;
          height = 34;
          margin-top = 0;
          margin-left = 0;
          margin-right = 0;
          margin-bottom = 0;

          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];

          modules-center = [
            "clock"
          ];

          modules-right = [
            "tray"
            "custom/updates"
            "network"
            "bluetooth"
            "battery"
            "wireplumber"
            "custom/power"
          ];

          "hyprland/window" = {
            format = "{}";
            max-length = 40;
            separate-outputs = true;
            rewrite = {
              "(.*) Visual Studio Code" = "code";
              "(.*) Chromium" = "chromium";
              "(.*) — Mozilla Firefox" = "firefox";
              "Alacritty" = "alacritty";
              "(.*) - Obsidian - (.*)" = "obsidian";
              "Spotify Premium" = "spotify";
              "(.*) - Google Chrome" = "chrome";
            };
          };

          "hyprland/workspaces" = {
            on-click = "activate";
            format = "{name}";
            persistent-workspaces = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
              "5" = [];
              "6" = [];
              "7" = [];
              "8" = [];
              "9" = [];
            };
          };

          tray = {
            icon-size = 16;
            spacing = 3;
          };

          clock = {
            interval = 1;
            format = "{:%d-%m-%y %H:%M}";
            format-alt = "   {:%H:%M     %Y, %d %B, %A} ";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              format = {
                days = "<span color='#ebdbb2'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ebdbb2'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
          };

          network = {
            format-icons = [
              "󰤟 "
              "󰤢 "
              "󰤥 "
              "󰤨 "
            ];
            format-ethernet = "󰈀 ";
            format-linked = "{ifname} (No IP) ";
            format = "{icon}";
            format-disconnected = "󰤭 ";
            on-click = "rofi-wifi-menu";
            on-click-right = "alacritty --hold --command nmtui";
            tooltip-format = " {bandwidthUpBits}  {bandwidthDownBits}\n{ifname}\n{ipaddr}/{cidr}\n";
            tooltip-format-wifi = " {essid} {frequency}MHz\nStrength: {signaldBm}dBm ({signalStrength}%)\nIP: {ipaddr}/{cidr}\n {bandwidthUpBits}  {bandwidthDownBits}";
            interval = 10;
          };

          bluetooth = {
            format = " ";
            format-disabled = "󰂳";
            format-connected = " ";
            tooltip-format = " {device_alias} 󰂄{device_battery_percentage}%";
            tooltip-format-enumerate-connected = " {device_alias} 󰂄{device_battery_percentage}%";
            tooltip = true;
            on-click = "rofi-bluetooth";
            on-click-right = "blueberry";
          };

          wireplumber = {
            on-click = "rofi -show rofi-sound -modi 'rofi-sound:rofi-sound-output-chooser'";
            on-click-right = "amixer sset Master toggle 1>/dev/null";
            format = "{icon}{volume}";
            format-muted = "󰝟 {volume}";
            tooltip-format = "{icon} {volume}%";
            format-source = "";
            format-source-muted = " ";
            format-icons = {
              default = [
                " "
                " "
                " "
                "  "
              ];
            };
          };

          cpu = {
            format = "󰍛 {usage}%";
            interval = 1;
            on-click = "gnome-system-monitor";
          };

          memory = {
            interval = 10;
            format = " {used:0.1f}G";
            format-alt-click = "click";
            tooltip = true;
            tooltip-format = "{used:0.1f}GB/{total:0.1f}G";
            on-click = "gnome-system-monitor";
          };

          battery = {
            format = "{icon}";
            format-icons = {
              charging = [
                "󰢜"
                "󰂆"
                "󰂇"
                "󰂈"
                "󰢝"
                "󰂉"
                "󰢞"
                "󰂊"
                "󰂋"
                "󰂅"
              ];
              default = [
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
            };
            interval = 5;
            states = {
              warning = 20;
              critical = 10;
            };
            tooltip = true;
          };

          "custom/power" = {
            format = "";
            tooltip = false;
            on-click = "$HOME/.config/rofi/powermenu.sh";
          };

          "custom/updates" = {
            format = " {}";
            exec = "checkupdates | wc -l";
            interval = 60;
            tooltip = false;
          };
        };
      };

      style = ''
        @define-color base #0c0c0c;
        @define-color text #F5E0DC;


        * {
          font-family: "Firacode Nerd Font";
          font-weight: bold;
          font-size: 100%;
        }

        window#waybar {
          background-color: @base;
          margin: 6px;
          padding: 0 4px;
        }

        window#waybar.hidden {
          opacity: 0.5;
        }

        #workspaces {
          background-color: @base;
          margin: 0 2px 0 2px;
          padding: 2px;
          border-radius: 5px;
        }

        #workspaces button {
          all: initial;
          min-width: 0;
          box-shadow: inset 0 -3px transparent;
          padding: 4px 10px;
          margin: 2px;
          color: @text;
          border-radius: 5px;
        }

        #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
          color: @base;
          background-color: @text;
          box-shadow: 0 0 0 1px #3A3A3C;
          border-radius: 5px;
        }

        #workspaces button.active {
          color: @base;
          background-color: @text;
          box-shadow: 0 0 0 1px #3A3A3C;
          border-radius: 5px;
        }

        #workspaces button.urgent {
          background-color: #f38ba8;
          color: @base;
          box-shadow: 0 0 0 1px #3A3A3C;
          border-radius: 5px;
        }

        #custom-updates {
          margin: 0 2px 0 4px;
          padding: 6px 12px;
          background-color: @base;
          color: @text;
          border-radius: 5px;
        }

        #cpu {
          margin: 0 4px 0 8px;
          background-color: @base;
          color: @text;
          border-radius: 5px;
        }

        #memory {
          margin: 0 12px 0 6px;
          background-color: @base;
          color: @text;
          border-radius: 5px;
        }

        #battery {
          margin: 0 2px 0 0px;
          padding: 0 12px 0 0px;
          background-color: @base;
          color: @text;
          border-radius: 5px;
        }

        #bluetooth {
          margin: 0 0px 0 2px;
          background-color: @base;
          color: @text;
          border-radius: 5px;
        }

        #wireplumber {
          margin: 0 12px 0 4px;
          background-color: @base;
          color: @text;
          border-radius: 5px;
        }

        #network {
          margin: 0 2px 0 4px;
          background-color: @base;
          color: @text;
          border-radius: 5px;
        }

        #clock {
          margin: 0 2px 0 4px;
          background-color: @base;
          color: @text;
          border-radius: 5px;
        }

        #tray {
          margin: 0 2px 0 4px;
          background-color: @base;
          color: @text;
          border-radius: 5px;
        }

        #window {
          margin: 0 2px 0 4px;
          padding: 6px 12px;
          background-color: @base;
          color: @text;
          border-radius: 5px;
        }

        #custom-power {
          margin: 0 0 0 4px;
          padding: 6px 16px 6px 12px;
          background-color: @base;
          color: @text;
          border-radius: 5px;
        }

        #battery.warning,
        #battery.critical,
        #battery.urgent,
        #battery.charging {
          background-color: @base;
          color: @text;
        }

        tooltip {
          background-color: @base;
        }

        tooltip label {
          padding: 4px;
          color: @text;
        }

      '';
    };
  };
}
