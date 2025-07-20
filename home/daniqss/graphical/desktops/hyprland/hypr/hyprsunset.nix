{
  pkgs,
  lib,
  config,
  ...
}: let
  sunsetTime = "21:00";
  sunriseTime = "08:00";
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

    # fuck it, just didn't figured out how to make the service work1
    wayland.windowManager.hyprland.settings.exec-once = [
      "sleep 2 && ${checkSunsetOnStart}/bin/checkSunsetOnStart"
    ];

    services.hyprsunset = {
      enable = true;
      extraArgs = ["--identity"];

      transitions = {
        sunrise = {
          calendar = "*-*-* ${sunriseTime}";
          requests = [
            ["temperature ${sunriseTemp}"]
            ["identity"]
          ];
        };

        sunset = {
          calendar = "*-*-* ${sunsetTime}";
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
