{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.graphical.hyprland.enable {
    services.hyprpolkitagent.enable = true;
  };
}
