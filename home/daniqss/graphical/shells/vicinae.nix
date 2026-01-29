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
        theme = {
          light = {
            name = "vicinae-light";
            icon_theme = "default";
          };
          dark = {
            name = "vicinae-dark";
            icon_theme = "default";
          };
        };
        window = {
          csd = false;
          opacity = 0.8;
          rounding = 5;
        };

        launcher_window = {
          opacity = 0.8;
        };

        # providers = {
        #   "@Gelei/bluetooth-0".preferences.connectionToggleable = true;
        # };
      };

      extensions = with inputs.vicinae-extensions.packages.${system}; [
        bluetooth
        nix
        wifi-commander
        awww-switcher
        pulseaudio
      ];
    };
  };
}
