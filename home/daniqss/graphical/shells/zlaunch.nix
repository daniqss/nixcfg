{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.zlaunch.homeManagerModules.default
  ];

  options.graphical.shells.zlaunch.enable = lib.mkEnableOption "enable zlaunch shell";

  config.services.zlaunch = lib.mkIf config.graphical.shells.zlaunch.enable {
    enable = true;
    systemd.enable = true;

    settings = {
      enable_backdrop = true;
      enable_transparency = false;
      hyprland_auto_blur = false;

      default_modes = ["combined" "emojis" "clipboard"];
      combined_modules = ["calculator" "windows" "applications" "actions" "clipboard"];

      fuzzy_match = {
        show_best_match = true;
      };

      search_providers = [
        {
          name = "GitHub";
          trigger = "!gh";
          url = "https://github.com/search?q={query}";
        }
      ];
    };
  };
}
