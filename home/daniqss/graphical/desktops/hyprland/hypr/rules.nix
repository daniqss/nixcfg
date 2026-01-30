{
  config,
  lib,
  ...
}: {
  config.wayland.windowManager.hyprland.settings = lib.mkIf (config.graphical.desktops.desktop == "hyprland") {
    windowrule = [
      "no_blur on, match:class ^(com.mitchellh.ghostty)$"

      "no_shadow on, match:focus 0"
      "rounding 12, match:float 1"

      "float on, center on, size (monitor_w*0.4) (monitor_h*0.5), match:class ^(pavucontrol)$"
      "float on, center on, size (monitor_w*0.4) (monitor_h*0.5), match:title ^(Enter name of file to save to…)$"
      "float on, center on, size (monitor_w*0.4) (monitor_h*0.5), match:class ^(blueman-manager)$"
      "float on, center on, size (monitor_w*0.4) (monitor_h*0.5), match:class ^(nm-applet)$"
      "float on, center on, size (monitor_w*0.4) (monitor_h*0.5), match:class ^(nm-connection-editor)$"
      "float on, center on, size (monitor_w*0.4) (monitor_h*0.5), match:class ^(blueberry.py)$"
      "center on, size (monitor_w*0.75) (monitor_h*0.85), match:class ^(discord)$"
      "center on, size (monitor_w*0.75) (monitor_h*0.85), match:class ^(Spotify)$"
      "float on, center on, size (monitor_w*0.5) (monitor_h*0.6), match:class ^(kitty)$"
      "float on, center on, size (monitor_w*0.4) (monitor_h*0.55), match:title ^(Lista de amigos)$"

      "suppress_event maximize, match:class .*"

      "immediate on, fullscreen on, match:class ^(Stardew Valley)$"
      "immediate on, fullscreen on, match:class ^(steam_app_367520)$"
      "immediate on, fullscreen on, match:class ^(Hollow Knight Silksong)$"
      "immediate on, fullscreen on, match:class ^(Minecraft [0-9]+(\.[0-9]+)*$)"
      "immediate on, fullscreen on, match:class ^(cs2)$"
      "immediate on, fullscreen on, match:class ^(steam_app_22380)$"
      "immediate on, fullscreen on, match:class ^(steam_app_1145360)$"
      "immediate on, fullscreen on, match:class ^(steam_app_1145360)$"
      "immediate on, fullscreen on, match:class ^(steam_app_3241660)$"
      "immediate on, fullscreen on, match:class ^(steam_app_3241660)$"
    ];

    layerrule = lib.mkMerge [
      (lib.mkIf config.graphical.shells.vicinae.enable [
        "blur on, match:namespace vicinae"
        "ignore_alpha 0, match:namespace vicinae"
      ])
      (lib.mkIf config.graphical.shells.quickshell.enable [
        "blur on, match:namespace quickshell"
        "ignore_alpha 0, match:namespace quickshell"
      ])
    ];

    workspace = [];
  };
}
