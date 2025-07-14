{lib, ...}: {
  imports = [
    ./ghostty.nix
    ./wezterm.nix
    ./alacritty.nix
  ];

  options.graphical.emulators = lib.mkOption {
    type = lib.types.enum ["alacritty" "wezterm" "ghostty"];
    default = "ghostty";
    description = "enables as default one of the available terminal emulators";
  };
}
