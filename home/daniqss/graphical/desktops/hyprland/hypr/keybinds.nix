{
  pkgs,
  lib,
  config,
  ...
}: let
  mainMod = "SUPER";
  scripts = config.graphical.rofi.scripts;

  defaultApp = pkgs.writeShellScriptBin "default-app" ''
    workspace_id=$(hyprctl -j activeworkspace | jq -r '.id')

    declare -A apps=(
      [1]="code"
      [2]="chromium"
      [3]="ghostty"
      [4]="obsidian"
      [5]="nautilus"
      [6]="vesktop"
      [7]="steam"
      [8]="spotify-launcher"
      [9]="google-chrome-stable"
    )

    app_command=''${apps[$workspace_id]}

    if [[ -n "$app_command" ]]; then
      hyprctl dispatch -- exec "[workspace ''${workspace_id} silent] uwsm app -- $app_command"
    fi
  '';
in {
  config = lib.mkIf config.graphical.hyprland.enable {
    home.packages = [
      defaultApp
      pkgs.hyprshot
    ];

    home.sessionVariables.HYPRSHOT_DIR = "$XDG_SCREENSHOTS_DIR";

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
          "${mainMod} CTRL, P, exec, ${scripts.powermenu}/bin/powermenu"

          "${mainMod}, 0, exec, default-app"
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
        ", Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
        "${mainMod}, M, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
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
