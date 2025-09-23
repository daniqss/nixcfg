{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) ghostty alacritty;

  allowedEmulators = [alacritty ghostty];

  emulatorType =
    lib.types.package
    // {
      check = pkg: builtins.elem pkg allowedEmulators;
    };
in {
  imports = [
    ./ghostty.nix
    ./alacritty.nix
  ];

  options.graphical.emulators = lib.mkOption {
    type = lib.types.submodule {
      options = {
        emulator = lib.mkOption {
          type = emulatorType;
          default = ghostty;
          description = "available terminal emulators";
        };

        fontsize = lib.mkOption {
          type = lib.types.ints.positive;
          default = 14;
          description = "wanted fontsize in the selected terminal emulator";
        };
      };
    };

    default = {};
    description = "terminal emulator config";
  };
}
