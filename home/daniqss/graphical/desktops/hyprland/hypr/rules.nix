{
  config,
  lib,
  ...
}: {
  config.wayland.windowManager.hyprland.settings = lib.mkIf config.graphical.hyprland.enable {
    workspace = [
      "1, persistent:true"
      "2, persistent:true"
      "3, persistent:true"
      "4, persistent:true"
      "5, persistent:true"
      "6, persistent:true"
      "7, persistent:true"
      "8, persistent:true"
      "9, persistent:true"
    ];
  };
}
