{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkDefault;
in {
  imports = [
    ./hypr
  ];

  config = mkIf (config.graphical.desktops.desktop == "hyprland") {
    graphical.desktops.monitorToDesktopConfig = monitors:
      builtins.map (
        monitor: let
          r = monitor.resolution;
          p = monitor.position;
          mirror =
            if monitor.mirror != ""
            then ",mirror,${monitor.mirror}"
            else "";
        in "${monitor.name},${toString r.x}x${toString r.y}@${monitor.refresh},${toString p.x}x${toString p.y},${monitor.scale}${mirror}"
      )
      monitors;

    graphical.shells.quickshell.enable = mkDefault true;
    graphical.shells.vicinae.enable = mkDefault false;

    services.zlaunch = {
      enable = mkDefault true;
      systemd.enable = mkDefault true;

      settings = {
        theme = "one-dark";
        launcher_size = [1000.0 600.0];
        enable_backdrop = true;
        enable_transparency = false;
        hyprland_auto_blur = false;

        default_modes = ["combined" "emojis" "clipboard"];
        combined_modules = ["calculator" "windows" "applications" "actions"];

        fuzzy_match = {
          show_best_match = true;
        };

        search_providers = {
          name = "GitHub";
          trigger = "!gh";
          url = "https://github.com/search?q={query}";
        };
      };
    };
  };
}
