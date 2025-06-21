{pkgs, ...}: let
  mainMod = "SUPER";
  border = "rgba(cba6f7ff) rgba(89b4faff) rgba(94e2d5ff) 10deg";

  hyprlandPackages = with pkgs; [
    swww
    alsa-utils
    playerctl
    ghostty
    rofi-wayland
  ];
in {
  home.packages = hyprlandPackages;

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = [
        "${pkgs.swww}/bin/swww-daemon && ${pkgs.swww}/bin/swww img /home/daniqss/image8.png}"
      ];

      monitor = [
        "DP-1,1920x1080@143.85,0x0,1.0"
      ];

      bind =
        [
          "${mainMod}, return, exec, ${pkgs.ghostty}/bin/ghostty"
          "${mainMod}, TAB, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun"
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
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
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

      general = {
        gaps_in = 6;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "${border}";
        "col.inactive_border" = "rgba(00000000)";
        layout = "dwindle";
        allow_tearing = true;

        snap = {
          enabled = true;
          window_gap = 15;
          monitor_gap = 25;
          border_overlap = true;
        };
      };

      decoration = {
        rounding = 8;

        blur = {
          enabled = true;
          size = 5;
          passes = 1;
          new_optimizations = true;
          special = true;
        };
      };

      animations = {
        enabled = true;
        bezier = "overshot, 0.13, 0.99, 0.29, 1.0";

        animation = [
          "windows, 1, 4, overshot, slide"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 0"
          "workspacesIn, 0"
          "workspacesOut, 0"
          "specialWorkspace, 1, 6, overshot, slidevert"
        ];
      };

      dwindle = {
        force_split = 0;
        special_scale_factor = 0.8;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        special_scale_factor = 0.8;
      };

      misc = {
        always_follow_on_dnd = false;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
        vfr = 1;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 250;
        workspace_swipe_invert = true;
        workspace_swipe_min_speed_to_force = 15;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = false;
      };

      cursor = {
        no_hardware_cursors = 1;
      };

      device = {
        name = "elan071a:00-04f3:30fd-touchpad";
        sensitivity = 0.1;
      };
    };
  };
}
