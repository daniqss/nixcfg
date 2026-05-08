{
  pkgs,
  lib,
  config,
  ...
}: let
  walker-bluetooth = pkgs.writeShellApplication {
    name = "walker-bluetooth";
    runtimeInputs = with pkgs; [bluez walker libnotify gnugrep gnused gawk];
    text = ''
      devices=$(bluetoothctl devices Paired || true)
      if [ -z "$devices" ]; then
        notify-send "Bluetooth" "No paired devices"
        exit 0
      fi
      labels=$(echo "$devices" | sed 's/^Device [^ ]* //')
      selected=$(echo "$labels" | walker --dmenu --placeholder "Bluetooth" || true)
      if [ -z "$selected" ]; then
        exit 0
      fi
      mac=$(echo "$devices" | grep -F "$selected" | awk '{print $2}')
      if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
        bluetoothctl disconnect "$mac"
        notify-send "Bluetooth" "Disconnected: $selected"
      else
        bluetoothctl connect "$mac" || true
        notify-send "Bluetooth" "Connecting: $selected"
      fi
    '';
  };

  walker-audio = pkgs.writeShellApplication {
    name = "walker-audio";
    runtimeInputs = with pkgs; [pulseaudio walker libnotify gnugrep gnused coreutils];
    text = ''
      descriptions=$(pactl list sinks | grep "Description:" | sed 's/.*Description: //' || true)
      if [ -z "$descriptions" ]; then
        notify-send "Audio" "No sinks found"
        exit 0
      fi
      selected=$(echo "$descriptions" | walker --dmenu --placeholder "Audio Output" || true)
      if [ -z "$selected" ]; then
        exit 0
      fi
      sink_name=$(pactl list sinks | grep -F -B20 "Description: $selected" | grep "Name:" | tail -1 | sed 's/.*Name: //' || true)
      if [ -n "$sink_name" ]; then
        pactl set-default-sink "$sink_name"
        notify-send "Audio" "$selected"
      fi
    '';
  };

  walker-wifi = pkgs.writeShellApplication {
    name = "walker-wifi";
    runtimeInputs = with pkgs; [networkmanager walker libnotify gnugrep coreutils];
    text = ''
      nmcli dev wifi rescan 2>/dev/null || true
      networks=$(nmcli -t -f SSID dev wifi list | grep -v '^$' | sort -u || true)
      if [ -z "$networks" ]; then
        notify-send "WiFi" "No networks found"
        exit 0
      fi
      selected=$(echo "$networks" | walker --dmenu --placeholder "WiFi" || true)
      if [ -z "$selected" ]; then
        exit 0
      fi
      nmcli dev wifi connect "$selected"
    '';
  };
in {
  options.graphical.shells.walker.enable = lib.mkEnableOption "enable walker as application launcher";

  config = lib.mkIf config.graphical.shells.walker.enable {
    home.packages = [
      pkgs.walker
      walker-bluetooth
      walker-audio
      walker-wifi
    ];

    xdg.configFile."walker/config.toml".text = ''
      [builtins.applications]
      actions = true
      context_aware = true
      show_generic = false

      [builtins.clipboard]
      max_entries = 30
      image_height = 200

      [builtins.emojis]
      history = true

      [builtins.windows]

      [builtins.runner]
    '';

    wayland.windowManager.hyprland.settings.exec-once = [
      "walker --gapplication-service"
    ];
  };
}
