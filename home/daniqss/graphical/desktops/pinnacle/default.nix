{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkDefault;
in {
  config = mkIf (config.graphical.desktops.desktop == "pinnacle") {
    graphical.desktops.monitorToDesktopConfig = monitors:
      builtins.map (
        monitor: let
          r = monitor.resolution;
          p = monitor.position;
        in "${monitor.name},${toString r.x}x${toString r.y}@${monitor.refresh},${toString p.x}x${toString p.y},${monitor.scale}"
      )
      monitors;

    graphical.desktops.uwsm.enable = mkDefault true;
    graphical.shells.shell = mkDefault "minimal";

    wayland.windowManager.pinnacle = {
      enable = true;

      # not sure how it works yet
      # config.execCmd = "/path/to/config?";

      systemd = {
        enable = true;
        useService = !config.graphical.desktops.uwsm.enable;
      };
    };
  };
}
