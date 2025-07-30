{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types mkEnableOption;
  cfg = config.graphical.shells;
in {
  imports = [
    ./quickshell
    ./minimal
  ];

  options.graphical.shells = {
    enable = mkEnableOption "desktop shells";

    shell = mkOption {
      type = types.enum ["quickshell" "minimal"];
      default = "quickshell";
      description = "available desktop shells";
    };

    commands = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      description = "available desktop shell commands";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services = {
      shell-bar = mkIf cfg.bar.enable {
        description = "Desktop shell bar";
        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        serviceConfig = {
          ExecStart = cfg.commands.bar;
          Restart = "on-failure";
        };
      };

      shell-notifications = mkIf cfg.notifications.enable {
        description = "Desktop shell notifications";
        wantedBy = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        serviceConfig = {
          ExecStart = cfg.commands.notifications;
          Restart = "on-failure";
        };
      };
    };

    home.packages = [
      cfg.commands.launcher
      cfg.commands.emoji
      cfg.commands.clipboard
      cfg.commands.sound
      cfg.commands.powermenu
      cfg.commands.wallpaper
      cfg.commands.bluetooth
    ];
  };
}
