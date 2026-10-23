{pkgs, ...}: {
  home = {
    stateVersion = "26.11";

    packages = with pkgs; [
      google-chrome
      calibre
      libreoffice-qt
      hunspellDicts.es_ES
      vlc
    ];
  };
}
