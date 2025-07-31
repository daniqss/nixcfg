{
  outputs,
  pkgs,
  lib,
  config,
  ...
}: let
  mainMod = "SUPER";
  shellCommands = config.graphical.shells.commands;
  emulator = config.graphical.emulators.emulator;
  prefix =
    if config.graphical.uwsm.enable
    then "uwsm app --"
    else "";

  switcher = ws:
    if config.graphical.hyprland.hyprqtile.enable
    then "${mainMod}, ${toString ws}, exec, hyprqtile -w ${toString ws}"
    else "${mainMod}, ${toString ws}, workspace, ${toString ws}";

  defaultApp = pkgs.writeShellScriptBin "default-app" ''
    #!/usr/bin/env bash

    workspace_id="''${1:-$(hyprctl -j activeworkspace | jq -r '.id')}"

    declare -A apps=(
      [1]="${lib.getExe pkgs.vscode}"
      [2]="${lib.getExe pkgs.chromium}"
      [3]="${lib.getExe emulator}"
      [4]="${lib.getExe pkgs.obsidian}"
      [5]="${lib.getExe pkgs.nautilus}"
      [6]="${lib.getExe pkgs.vesktop}"
      [7]="${lib.getExe pkgs.steam}"
      [8]="${lib.getExe pkgs.spotify}"
      [9]="${lib.getExe pkgs.google-chrome}"
    )

    hyprctl dispatch exec -- [workspace ''${workspace_id} silent] ${prefix} ''${apps[''$workspace_id]}
  '';
in {
  config = lib.mkIf config.graphical.hyprland.enable {
    home.packages = [
      outputs.packages.${pkgs.system}.hyprqtile
      defaultApp
      pkgs.hyprshot
      pkgs.jq
    ];

    home.sessionVariables.HYPRSHOT_DIR = "$XDG_SCREENSHOTS_DIR";

    wayland.windowManager.hyprland.settings = {
      bind =
        [
          "${mainMod}, return, exec, ${lib.getExe emulator}"
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

          "${mainMod}, TAB, exec, ${lib.getExe shellCommands.applauncher}"
          "${mainMod} CTRL, W, exec, ${lib.getExe shellCommands.wallpaper}"
          "${mainMod} CTRL, B, exec, ${prefix} ${lib.getExe shellCommands.bluetooth}"
          "${mainMod} CTRL, S, exec, ${lib.getExe shellCommands.sound}"
          "${mainMod} CTRL, E, exec, ${lib.getExe shellCommands.emoji}"
          "${mainMod} CTRL, C, exec, ${lib.getExe shellCommands.clipboard}"
          "${mainMod} CTRL, P, exec, ${lib.getExe shellCommands.powermenu}"

          "${mainMod}, 0, exec, default-app"
        ]
        ++ (
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                (switcher ws)
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
