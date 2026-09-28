{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) chromium google-chrome;
  inherit (lib) mkIf;
  cfg = config.graphical.browsers;
  availableBrowsers = [chromium google-chrome];
in {
  imports = [
    ./chromium.nix
    ./chrome.nix
  ];

  options.graphical.browsers = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "use browsers from home manager";

        dev = lib.mkOption {
          type = lib.types.enum availableBrowsers;
          default = chromium;
          description = "dev browser";
        };

        media = lib.mkOption {
          type = lib.types.enum availableBrowsers;
          default = google-chrome;
          description = "multimedia browser";
        };
      };
    };

    description = "used browsers";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      firefox
    ];
  };
}
