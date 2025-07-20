{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) chromium google-chrome;

  availableBrowsers = [chromium google-chrome];
in {
  imports = [
    ./chromium.nix
    ./chrome.nix
  ];

  options.graphical.browsers = lib.mkOption {
    type = lib.types.submodule {
      options = {
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
}
