{
  inputs,
  system,
  lib,
  config,
  ...
}: {
  imports = [inputs.vicinae.homeManagerModules.default];

  options.graphical.shells.vicinae = {
    enable = lib.mkEnableOption "enable vicinae shell";
  };

  config = lib.mkIf config.graphical.shells.vicinae.enable {
    services.vicinae = {
      enable = true;
      systemd.enable = true;

      settings = {
        close_on_focus_loss = true;

        providers = {
          # "@sovereign/awww-switcher-0" = {
          #   favorite = true;
          #   preferences = {
          #     wallpaperPath = "/home/daniqss/nixcfg/assets/wallpapers/current";
          #     colorGenTool = "matugen";

          #     gridRows = "4"; # 3|4|5|6
          #     showImageDetails = true;
          #     transitionType = "none"; # none|simple|fade|left|right|top|bottom|wipe|wave|grow|center|any|outer|random
          #     transitionDuration = "1"; # seconds
          #     transitionStep = "90"; # color steps: 1|45|90|120|200|255
          #     transitionFPS = "60";
          #     toggleVicinaeSetting = false;
          #     postProduction = "no"; # no|grayscale|grayscaleblur|lightblur|heavyblur|negate
          #   };
          # };

          "@rastsislaux/pulseaudio-0" = {
            favorite = true;
            preferences = {
              show_volume = true;
            };
          };
        };
      };

      extensions = with inputs.vicinae-extensions.packages.${system}; [
        bluetooth
        nix
        wifi-commander
        # awww-switcher
        pulseaudio
      ];
    };
  };
}
