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
    graphical.shells.zlaunch.enable = mkDefault true;
  };
}
