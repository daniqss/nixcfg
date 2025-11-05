{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkDefault;
in {
  imports = [
    ./hypr
  ];

  options.graphical.desktops.hyprland.hyprqtile.enable = mkEnableOption "enable hyprqtile as workspace switcher";

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

    graphical.desktops.uwsm.enable = mkDefault false;
    graphical.desktops.hyprland.hyprqtile.enable = mkDefault false;
    graphical.shells.shell = mkDefault "quickshell";
  };
}
