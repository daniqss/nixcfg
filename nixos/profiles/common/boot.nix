{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.common.boot;
in {
  options.common.boot = {
    enable = lib.mkEnableOption "limine as the EFI bootloader" // {default = true;};

    maxGenerations = lib.mkOption {
      type = lib.types.int;
      default = 5;
      description = "maximum number of generations shown in the limine menu";
    };

    # needs sbctl keys in /var/lib/sbctl already enrolled in the firmware
    secureBoot.enable = lib.mkEnableOption "secure boot, signing limine with sbctl";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.efi.canTouchEfiVariables = true;

    boot.loader.limine = {
      enable = true;
      inherit (cfg) maxGenerations;

      secureBoot = {
        inherit (cfg.secureBoot) enable;
      };

      # catppuccin mocha rosewater
      style = {
        wallpapers = [];

        interface = {
          brandingColor = "f5e0dc";
          helpColor = "f5e0dc";
          helpColorBright = "f5e0dc";
        };

        graphicalTerminal = {
          palette = "1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
          brightPalette = "585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4";
          background = "1e1e2e";
          foreground = "cdd6f4";
          brightBackground = "585b70";
          brightForeground = "cdd6f4";
        };
      };
    };

    environment.systemPackages = lib.mkIf cfg.secureBoot.enable [pkgs.sbctl];
  };
}
