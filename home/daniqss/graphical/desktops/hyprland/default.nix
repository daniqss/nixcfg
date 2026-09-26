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
      monitors
      |> map (
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
      |> builtins.concatStringsSep "\n";

    graphical.desktops.layoutsToDesktopConfig = layouts:
      builtins.concatStringsSep ", " layouts;

    # kb_variant is positional: one entry per layout, empty means default
    graphical.desktops.variantsToDesktopConfig = layouts:
      layouts
      |> map (layout: config.graphical.desktops.variants.${layout} or "")
      |> builtins.concatStringsSep ",";

    graphical.shells.quickshell.enable = mkDefault true;
    graphical.shells.vicinae.enable = mkDefault true;
  };
}
