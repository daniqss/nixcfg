{lib, ...}: let
  vec2 = lib.types.submodule {
    options = {
      x = lib.mkOption {
        type = lib.types.int;
        description = "x component";
        default = 0;
      };
      y = lib.mkOption {
        type = lib.types.int;
        description = "y component";
        default = 0;
      };
    };
  };
in {
  imports = [
    ./hyprland
    ./pinnacle
    ./theme
  ];

  options.graphical.desktops = {
    desktop = lib.mkOption {
      type = lib.types.enum ["hyprland" "pinnacle" "none"];
      default = "none";
      description = "which desktop to use";
    };

    monitorToDesktopConfig = lib.mkOption {
      type = lib.types.unspecified;
      description = "generate the config for the desktop from the monitors option";
    };

    monitors = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "name of the monitor";
          };

          resolution = lib.mkOption {
            type = vec2;
            description = "monitor resolution";
          };

          refresh = lib.mkOption {
            type = lib.types.str;
            description = "refresh rate";
          };

          position = lib.mkOption {
            type = vec2;
            description = "position of the monitor";
          };

          scale = lib.mkOption {
            type = lib.types.str;
            description = "scale of the monitor";
          };

          mirror = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "name of the monitor to mirror";
          };
        };
      });
    };
  };

  options.graphical.desktops.uwsm.enable = lib.mkEnableOption "enable uwsm as session manager";
}
