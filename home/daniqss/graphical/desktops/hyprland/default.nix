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
      builtins.concatStringsSep "\n" (map (
          monitor: let
            r = monitor.resolution;
            p = monitor.position;
            scale =
              if monitor.scale == "auto"
              then ''"auto"''
              else monitor.scale;
            mirror = lib.optionalString (monitor.mirror != "") "\n\tmirror = \"${monitor.mirror}\",";
          in ''
            hl.monitor({
            	output = "${monitor.name}",
            	mode = "${toString r.x}x${toString r.y}@${monitor.refresh}",
            	position = "${toString p.x}x${toString p.y}",
            	scale = ${scale},${mirror}
            })''
        )
        monitors);

    graphical.desktops.layoutsToDesktopConfig = layouts:
      builtins.concatStringsSep ", " layouts;

    graphical.shells.quickshell.enable = mkDefault true;
    graphical.shells.vicinae.enable = mkDefault true;
  };
}
