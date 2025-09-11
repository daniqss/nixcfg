{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) chromium google-chrome ungoogled-chromium;

  availableBrowsers = [chromium google-chrome ungoogled-chromium];
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
          default = ungoogled-chromium;
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
