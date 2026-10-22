{pkgs, ...}: {
  bibata-hyprcursor = pkgs.callPackage ./bibata-hyprcursor {};
  adwaita-colors = pkgs.callPackage ./adwaita-colors {};
  dirlock = pkgs.callPackage ./dirlock {};
  hitcountermanager = pkgs.callPackage ./hitcountermanager {};
  libsocketcan = pkgs.callPackage ./libsocketcan.nix {};
  spotifast = pkgs.callPackage ./spotifast {};
}
