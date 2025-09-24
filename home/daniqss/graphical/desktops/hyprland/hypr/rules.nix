{
  config,
  lib,
  ...
}: {
  config.wayland.windowManager.hyprland.settings = lib.mkIf config.graphical.hyprland.enable {
    windowrule = ["noblur, class:^(com.mitchellh.ghostty)"];

    windowrulev2 = [
      "noshadow off, focus: 0"
      "rounding 12, floating: 1"

      "float, class:^(pavucontrol)$"
      "float, title:^(Enter name of file to save to…)$"
      "float, class:^(blueman-manager)$"
      "float, class:^(blueberry.py)$"
      "float, class:^(nm-applet)$"
      "float, class:^(nm-connection-editor)$"
      "float, class:^(discord)$"
      "float, class:^(steam)$, title:^(Lista de amigos)$"
      "float, class:^(it.mijorus.smile)$"

      "size 40% 50%, class:^(pavucontrol)$"
      "size 40% 50%, title:^(Enter name of file to save to…)$"
      "size 40% 50%, class:^(blueman-manager)$"
      "size 40% 50%, class:^(nm-applet)$"
      "size 40% 50%, class:^(nm-connection-editor)$"
      "size 40% 50%, class:^(blueberry.py)$"
      "size 75% 85%, class:^(discord)$"
      "size 75% 85%, class:^(Spotify)$"
      "size 50% 60%, class:^(kitty)$"
      "size 40% 55%, title:^(Lista de amigos)$"

      "center 1, class:^(pavucontrol)$"
      "center 1, class:^(blueman-manager)$"
      "center 1, class:^(blueberry.py)$"
      "center 1, class:^(nm-applet)$"
      "center 1, class:^(nm-connection-editor)$"
      "center 1, class:^(discord)$"
      "center 1, class:^(Spotify)$"
      "center 1, class:^(kitty)$"
      "center 1, class:^(steam)$, title:^(Lista de amigos)$"

      "suppressevent maximize, class:.*"

      "immediate, class:^(Stardew Valley)$"
      "fullscreen, class:^(Stardew Valley)$"
      "immediate, class:^(Hollow_Knight.exe)$"
      "fullscreen, class:^(Hollow_Knight.exe)$"
      "immediate, class:^(Hollow Knight Silksong)$"
      "fullscreen, class:^(Hollow Knight Silksong)$"
      "immediate, class:^(Minecraft* 1.21.8)$"
      "fullscreen, class:^(Minecraft* 1.21.8)$"
      "immediate, class:^(cs2)$"
      "fullscreen, class:^(cs2)$"
      "immediate, class:^(steam_app_22380)$"
      "fullscreen, class:^(steam_app_22380)$"
      "immediate, class:^(steam_app_1145360)$"
      "fullscreen, class:^(steam_app_1145360)$"
      "immediate, class:^(steam_app_3241660)$"
      "fullscreen, class:^(steam_app_3241660)$"
    ];

    layerrule = lib.mkIf (config.graphical.enable && (config.graphical.shells.shell == "quickshell")) [
      "blur, quickshell"
      "ignorezero, quickshell"
    ];

    workspace = [];
  };
}
