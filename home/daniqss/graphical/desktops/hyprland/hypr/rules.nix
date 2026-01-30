{
  config,
  lib,
  ...
}: {
  config.wayland.windowManager.hyprland.settings = lib.mkIf (config.graphical.desktops.desktop == "hyprland") {
    windowrule = [
      # Ghostty
      "no_blur on, match:class ^(com.mitchellh.ghostty)$"

      # Global rules
      "no_shadow on, match:focus 0"
      "rounding 12, match:float 1"

      # Float rules
      "float on, match:class ^(pavucontrol)$"
      "float on, match:title ^(Enter name of file to save to…)$"
      "float on, match:class ^(blueman-manager)$"
      "float on, match:class ^(blueberry.py)$"
      "float on, match:class ^(nm-applet)$"
      "float on, match:class ^(nm-connection-editor)$"
      "float on, match:class ^(discord)$"
      "float on, match:class ^(steam)$, match:title ^(Lista de amigos)$"
      "float on, match:class ^(it.mijorus.smile)$"

      # Size rules
      "size (monitor_w*0.4) (monitor_h*0.5), match:class ^(pavucontrol)$"
      "size (monitor_w*0.4) (monitor_h*0.5), match:title ^(Enter name of file to save to…)$"
      "size (monitor_w*0.4) (monitor_h*0.5), match:class ^(blueman-manager)$"
      "size (monitor_w*0.4) (monitor_h*0.5), match:class ^(nm-applet)$"
      "size (monitor_w*0.4) (monitor_h*0.5), match:class ^(nm-connection-editor)$"
      "size (monitor_w*0.4) (monitor_h*0.5), match:class ^(blueberry.py)$"
      "size (monitor_w*0.75) (monitor_h*0.85), match:class ^(discord)$"
      "size (monitor_w*0.75) (monitor_h*0.85), match:class ^(Spotify)$"
      "size (monitor_w*0.5) (monitor_h*0.6), match:class ^(kitty)$"
      "size (monitor_w*0.4) (monitor_h*0.55), match:title ^(Lista de amigos)$"

      # Center rules
      "center on, match:class ^(pavucontrol)$"
      "center on, match:class ^(blueman-manager)$"
      "center on, match:class ^(blueberry.py)$"
      "center on, match:class ^(nm-applet)$"
      "center on, match:class ^(nm-connection-editor)$"
      "center on, match:class ^(discord)$"
      "center on, match:class ^(Spotify)$"
      "center on, match:class ^(kitty)$"
      "center on, match:class ^(steam)$, match:title ^(Lista de amigos)$"

      # Suppress maximize everywhere
      "suppress_event maximize, match:class .*"

      # Games (immediate + fullscreen)
      "immediate on, match:class ^(Stardew Valley)$"
      "fullscreen on, match:class ^(Stardew Valley)$"

      "immediate on, match:class ^(steam_app_367520)$"
      "fullscreen on, match:class ^(steam_app_367520)$"

      "immediate on, match:class ^(Hollow Knight Silksong)$"
      "fullscreen on, match:class ^(Hollow Knight Silksong)$"

      "immediate on, match:class ^(Minecraft.* 1.21.8)$"
      "fullscreen on, match:class ^(Minecraft.* 1.21.8)$"

      "immediate on, match:class ^(cs2)$"
      "fullscreen on, match:class ^(cs2)$"

      "immediate on, match:class ^(steam_app_22380)$"
      "fullscreen on, match:class ^(steam_app_22380)$"

      "immediate on, match:class ^(steam_app_1145360)$"
      "fullscreen on, match:class ^(steam_app_1145360)$"

      "immediate on, match:class ^(steam_app_3241660)$"
      "fullscreen on, match:class ^(steam_app_3241660)$"
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
