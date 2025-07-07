{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.graphical.enable {
    home.packages = with pkgs; [wezterm];

    xdg.configFile."wezterm" = {
      source = ./wezterm;
      recursive = true;
    };
  };
}
