{pkgs, ...}: {
  bibata-hyprcursor = pkgs.callPackage ./bibata-hyprcursor {};
  adwaita-colors = pkgs.callPackage ./adwaita-colors {};
}
