{
  pkgs,
  lib,
  config,
  ...
}: let
  sunsetTime = "21";
  sunriseTime = "8";
  sunsetTemp = "3000";
  sunriseTemp = "6500";

  checkSunsetOnStart = pkgs.writeShellScriptBin "checkSunsetOnStart" ''
    hour=$(date +%H)
    if [ "''$hour" -ge ${sunsetTime} ] || [ "''$hour" -lt ${sunriseTime} ]; then
      echo "after ${sunsetTemp} -> setting temperature at ${sunsetTemp}"
      hyprctl hyprsunset temperature ${sunsetTemp}
    else
      echo "before ${sunriseTime} -> not setting temperature"
    fi
  '';
in {
  config = lib.mkIf config.graphical.hyprland.enable {
    home.packages = [
      checkSunsetOnStart
    ];

    wayland.windowManager.hyprland.settings.exec-once = [
      "sleep 1 && ${checkSunsetOnStart}/bin/checkSunsetOnStart"
    ];

    services.hyprsunset = {
      enable = true;
      extraArgs = ["--identity"];

      transitions = {
        sunrise = {
          calendar = "*-*-* 0${sunriseTime}:00";
          requests = [
            ["temperature ${sunriseTemp}"]
            ["identity"]
          ];
        };

        sunset = {
          calendar = "*-*-* ${sunsetTime}:00";
          requests = [["temperature ${sunsetTemp}"]];
        };
      };
    };

    # systemd.user.services."checkSunsetOnStart" = {
    #   Unit = {
    #     Description = "check if its required to change the temperatura on start";
    #     After = ["hyprsunset.service"];
    #     Requires = ["hyprsunset.service"];
    #   };

    #   Install.WantedBy = ["default.target"];

    #   Service = {
    #     Type = "oneshot";
    #     ExecStart = checkSunsetOnStart;
    #   };
    # };
  };
}
