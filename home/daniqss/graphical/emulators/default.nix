{
  outputs,
  pkgs,
  ...
}: let
  inherit (outputs.lib) mkProgramGroupOptions mkFontOptions;
in {
  imports = [
    ./ghostty.nix
    ./alacritty.nix
  ];

  options.graphical.emulators =
    mkProgramGroupOptions {
      description = "available terminal emulators";
      packages = with pkgs; [ghostty alacritty];
      default = pkgs.ghostty;
    }
    // {
      font = mkFontOptions {
        family = "CaskaydiaCove Nerd Font Mono";
        size = 13;
      };
    };
}
