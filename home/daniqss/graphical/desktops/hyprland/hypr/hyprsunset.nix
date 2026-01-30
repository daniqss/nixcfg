{
  pkgs,
  lib,
  config,
  ...
}: let
  sunsetTime = "21";
  sunriseTime = "8";
  sunsetTemp = "3000";

  checkSunsetOnStart = pkgs.writeShellScriptBin "checkSunsetOnStart" ''
    hour=$(${lib.getExe' pkgs.coreutils "date"} +%H)
    if [ "''$hour" -ge ${sunsetTime} ] || [ "''$hour" -lt ${sunriseTime} ]; then
      echo "after ${sunsetTemp} -> setting temperature at ${sunsetTemp}"
      hyprctl hyprsunset temperature ${sunsetTemp}
    else
      echo "before ${sunriseTime} -> disabling blue-light filter"
      hyprctl hyprsunset identity
    fi
  '';
in {
  config = lib.mkIf (config.graphical.desktops.desktop == "hyprland") {
    home.packages = [checkSunsetOnStart];

    # change temperature in sunrise and sunset
    services.hyprsunset = {
      enable = true;
      package = pkgs.unstable.hyprsunset;
    };
  };
}
