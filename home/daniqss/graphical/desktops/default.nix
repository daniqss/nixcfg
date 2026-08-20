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
    ./theme
  ];

  options.graphical.desktops = {
    desktop = lib.mkOption {
      type = lib.types.enum ["hyprland" "none"];
      default = "none";
      description = "which desktop to use";
    };

    layouts = lib.mkOption {
      type = lib.types.listOf (lib.types.enum ["us" "es"]);
      default = ["us" "es"];
      description = "keyboard layouts";
    };

    variants = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        # altgr-intl deja el teclado americano intacto y pone los acentos en
        # AltGr: AltGr+n = ñ, AltGr+' y vocal = á, AltGr+" y vocal = ü
        us = "altgr-intl";
        es = "";
      };
      description = "xkb variant to use for each keyboard layout";
    };

    layoutsToDesktopConfig = lib.mkOption {
      type = lib.types.unspecified;
      description = "generate layout config from options";
    };

    variantsToDesktopConfig = lib.mkOption {
      type = lib.types.unspecified;
      description = "generate variant config from options";
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
}
