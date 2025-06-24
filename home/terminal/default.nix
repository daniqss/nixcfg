{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./zsh.nix
    ./git.nix
  ];
  options.terminal.enable = lib.mkEnableOption "Enable some terminal";

  config = lib.mkIf config.terminal.enable {
    home.packages = with pkgs; [
      bat
      eza
      wl-clipboard
      cliphist
      killall
    ];
  };
}
