{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    nixd
    statix
    deadnix
  ];
}
