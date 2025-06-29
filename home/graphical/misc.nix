{pkgs, ...}: let
in {
  home.packages = with pkgs; [
    gnome-calculator
  ];
}
