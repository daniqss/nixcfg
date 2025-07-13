{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.graphical.enable {
    programs.wezterm.enable = true;

    xdg.configFile."wezterm" = {
      source = ./wezterm;
      recursive = true;
    };
  };
}
