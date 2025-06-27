{
  pkgs,
  lib,
  config,
  ...
}: let
  mainMod = "SUPER";
  scripts = config.graphical.rofi.scripts;
in {
  config = lib.mkIf config.graphical.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      bind =
        [
          "${mainMod}, return, exec, ${pkgs.ghostty}/bin/ghostty"
          "${mainMod}, W, killactive,"
          "${mainMod}, Q, togglefloating,"
          "${mainMod}, F, fullscreen,"
          "${mainMod}, O, pseudo,"
          "${mainMod}, I, togglesplit,"

          "${mainMod}, H, movefocus, l"
          "${mainMod}, L, movefocus, r"
          "${mainMod}, J, movefocus, u"
          "${mainMod}, K, movefocus, d"

          "${mainMod}, S, togglespecialworkspace, magic"
          "${mainMod} ALT, S, movetoworkspacesilent, special:magic"

          "${mainMod}, TAB, exec, ${scripts.applauncher}/bin/applauncher"
          "${mainMod} CTRL, W, exec, ${scripts.wallpaper}/bin/wallpaper"
          "${mainMod} CTRL, B, exec, ${scripts.bluetooth}/bin/bluetooth"
          "${mainMod} CTRL, S, exec, ${scripts.sound}/bin/sound"
          "${mainMod} CTRL, E, exec, ${scripts.emoji}/bin/emoji"
          "${mainMod} CTRL, C, exec, ${scripts.clipboard}/bin/clipboard"
        ]
        ++ (
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "${mainMod}, ${toString ws}, workspace, ${toString ws}"
                "${mainMod} ALT, ${toString ws}, movetoworkspacesilent, ${toString ws}"
              ]
            )
            9)
        );

      # Volume control binds
      bindle = [
        ", XF86AudioRaiseVolume, exec, ${pkgs.alsa-utils}/bin/amixer set Master 5%+"
        ", XF86AudioLowerVolume, exec, ${pkgs.alsa-utils}/bin/amixer set Master 5%-"
        ", XF86AudioMute, exec, ${pkgs.alsa-utils}/bin/amixer set Master toggle"
        "${mainMod}, XF86AudioLowerVolume, exec, ${pkgs.playerctl}/bin/playerctl previous"
        "${mainMod}, XF86AudioMute, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        "${mainMod}, XF86AudioRaiseVolume, exec, ${pkgs.playerctl}/bin/playerctl next"
      ];

      # Single press media control binds
      bindl = [
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
        ", Print, exec, $screenshot"
      ];

      # Repeat binds for window resizing
      binde = [
        "${mainMod} CTRL, L, resizeactive, 30 0"
        "${mainMod} CTRL, H, resizeactive, -30 0"
        "${mainMod} CTRL, K, resizeactive, 0 -30"
        "${mainMod} CTRL, J, resizeactive, 0 30"
        "${mainMod} SHIFT, H, swapwindow, l"
        "${mainMod} SHIFT, L, swapwindow, r"
        "${mainMod} SHIFT, J, swapwindow, d"
        "${mainMod} SHIFT, K, swapwindow, u"
      ];

      # Mouse binds for moving and resizing
      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];
    };
  };
}
