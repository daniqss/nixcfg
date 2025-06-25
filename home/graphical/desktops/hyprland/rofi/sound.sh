#!/usr/bin/env bash

set -euo pipefail

export LC_NUMERIC=C

sinks_json=$(pactl -f json list sinks)
current_sink=$(pactl get-default-sink)

descriptions=()
mapfile -t descriptions < <(echo "$sinks_json" | jq -r '.[].description')

names=()
mapfile -t names < <(echo "$sinks_json" | jq -r '.[].name')

# like alsa_output.pci-0000_04_00.1.hdmi-stereo
current_index=$(echo "$sinks_json" | jq -r --arg current "$current_sink" '
  map(.name) | to_entries | map(select(.value == $current)) | .[0].key')

selected_description=$(printf '%s\n' "${descriptions[@]}" | rofi -dmenu -selected-row "$current_index")

[[ -z "$selected_description" ]] && exit 0

selected_name=$(echo "$sinks_json" | jq -r --arg desc "$selected_description" '
  .[] | select(.description == $desc) | .name')

if pactl set-default-sink "$selected_name"; then
  notify-send "Activated: $selected_description"
else
  notify-send "Error activating: $selected_description"
  exit 1
fi
