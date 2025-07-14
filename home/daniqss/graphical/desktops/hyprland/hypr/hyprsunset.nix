{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.graphical.hyprland.enable {
    systemd.user.timers.hyprsunset = {
      description = "start hyprsunset after sunset";
      enable = true;
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* 21:00:00";
      };
    };
    systemd.user.services.hyprsunset = {
      enable = true;
      description = "starts hyprsunset for blue light filtering";
      after = ["graphical.target"];
      serviceConfig = {
        ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t 3000";
      };
    };
  };
}
