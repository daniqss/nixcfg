{lib, ...}: {
  imports = [
    ./ghostty.nix
    ./alacritty.nix
  ];

  options.graphical.emulators = lib.mkOption {
    type = lib.types.submodule {
      options = {
        emulator = lib.mkOption {
          type = lib.types.enum ["ghostty" "alacritty" "none"];
          default = "none";
          description = "available terminal emulators";
        };

        fontsize = lib.mkOption {
          type = lib.types.ints.positive;
          default = 14;
          description = "wanted fontsize in the selected terminal emulator";
        };
      };
    };

    description = "terminal emulator config";
  };
}
