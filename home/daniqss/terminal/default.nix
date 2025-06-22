{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  options.terminal.enable = lib.mkEnableOption "Enable graphical session";

  config = lib.mkIf config.terminal.enable {
    imports = [
      ./zsh.nix
      ./git.nix
    ];

    home.packages = with pkgs; [
      bat
      eza
      wl-clipboard
      cliphist
    ];
  };
}
