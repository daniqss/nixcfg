{
  config,
  lib,
  ...
}: {
  config.wayland.windowManager.hyprland.settings = lib.mkIf config.graphical.hyprland.enable {
    workspace = [];
  };
}
