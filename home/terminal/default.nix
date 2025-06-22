{pkgs, ...}: let
in {
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
}
