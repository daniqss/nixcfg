{
  hostname,
  username,
  outputs,
  pkgs,
  lib,
  config,
  ...
}: let
  activeBorderColor = "rgba(cba6f7ff) rgba(89b4faff) rgba(94e2d5ff) 10deg";
  inactiveBorderColor = "rgb(313244)";
  shadowColor = "rgb(11111b)";

  monitors =
    if hostname == "stoneward"
    then [
      "DP-1,1920x1080@143.85,0x0,1.0"
    ]
    else if hostname == "windrunner"
    then [
      "eDP-1,1920x1080@60.06,0x0, 1.0"
      "HDMI-A-1,1920x1080@60.06,0x0,1.0,mirror, eDP-1"
    ]
    else null;

  cursor = "Bibata-Modern-Classic-Hyprcursor";
  cursorSize = 24;
  cursorPackage = outputs.packages.${pkgs.system}.bibata-hyprcursor;
in {
  imports = [
    ./keybinds.nix

    ./hypridle.nix
    ./hyprlock.nix
    ./hyprsunset.nix
    ./hyprpolkitagent.nix
  ];

  config = lib.mkIf config.graphical.hyprland.enable {
    xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;

      extraConfig = "source = ${config.xdg.configHome}/hypr/programs.conf";

      settings = {
        env = [
          "HYPRCURSOR_THEME, ${cursor}"
          "HYPRCURSOR_SIZE, ${toString cursorSize}"
          "HYPRSHOT_DIR, /home/${username}/Pictures/screenshots"

          "NIXOS_OZONE_WL, 1"
        ];

        exec-once = [
          "hyprctl setcursor ${cursor} ${toString cursorSize}"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          (
            if config.graphical.quickshell.enable
            then "qs"
            else ""
          )
        ];

        monitor = monitors;

        general = {
          gaps_in = 4;
          gaps_out = 8;

          border_size = 2;
          "col.active_border" = "${activeBorderColor}";
          "col.inactive_border" = "${inactiveBorderColor}";

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
          rounding = 10;
          rounding_power = 2;

          blur = {
            enabled = false;
            size = 8;
            passes = 2;

            vibrancy = 0.1696;
            brightness = 0.5;

            special = true;
          };

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "${shadowColor}";
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
      };
    };
  };
}
