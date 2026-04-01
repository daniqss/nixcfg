{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.graphical.desktops.desktop == "hyprland") {
    services.hyprsunset = {
      enable = true;
      package = pkgs.unstable.hyprsunset;

      settings = {
        profile = [
          {
            time = "7:30";
            temperature = 6500;
            identity = true;
          }
          {
            time = "21:00";
            temperature = 3000;
          }
        ];
      };
    };
  };
}
