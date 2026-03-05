{
  pkgs,
  lib,
  ...
}: let
  availableBrowsers = [pkgs.chromium pkgs.unstable.chromium pkgs.google-chrome pkgs.unstable.google-chrome];
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
          default = pkgs.chromium;
          description = "dev browser";
        };

        media = lib.mkOption {
          type = lib.types.enum availableBrowsers;
          default = pkgs.google-chrome;
          description = "multimedia browser";
        };
      };
    };

    description = "used browsers";
  };
}
