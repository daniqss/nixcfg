{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.graphical.desktops.desktop == "hyprland") {
    services.hyprpolkitagent.enable = true;
  };
}
