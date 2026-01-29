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
        providers = {
          #   "@Gelei/bluetooth-0".preferences.connectionToggleable = true;
          "@sovereign/store.vicinae.awww-switcher".preferences = {
            colorGenTool = "matugen";
            postCommand = "cp $''{wallpaper} ~/.cache/lock_background";
            transitionDuration = "2";
            transitionStep = "90";
            transitionType = "outer";
            wallpaperPath = "~/nixcfg/assets/wallpapers";
          };
        };
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
