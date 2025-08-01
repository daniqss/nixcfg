{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.graphical.shells;
in {
  imports = [
    ./quickshell
    ./minimal
  ];

  options.graphical.shells = {
    shell = mkOption {
      type = types.enum ["quickshell" "minimal"];
      default = "quickshell";
      description = "available desktop shells";
    };

    commands = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = {};
      description = "available desktop shell commands";
    };
  };

  config = mkIf config.graphical.enable {
    systemd.user.services.shell-bar = {
      Unit = {
        Description = "start shell bar";
        After = "wayland-wm@Hyprland.service";
      };
      Service = {
        ExecStart = lib.getExe cfg.commands.bar;
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install.WantedBy = ["graphical-session.target"];
    };

    home.packages = with cfg.commands; [
      bar
      applauncher
      emoji
      clipboard
      sound
      powermenu
      wallpaper
      bluetooth
    ];
  };
}
