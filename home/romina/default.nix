{
  nixosConfig,
  username,
  pkgs,
  ...
}: {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = nixosConfig.system.nixos.release;

    sessionVariables = {
      XDG_DESKTOP_DIR = "$HOME";
      XDG_DOCUMENTS_DIR = "$HOME/Documents";
      XDG_DOWNLOAD_DIR = "$HOME/Downloads";
      XDG_PICTURES_DIR = "$HOME/Pictures";
      XDG_VIDEOS_DIR = "$HOME/Videos";
    };

    # apps requested for romina (KDE base comes from the nixos plasma profile)
    packages = with pkgs; [
      calibre
      qbittorrent

      # common utilities
      vlc
      libreoffice-fresh
      keepassxc
      unzip
      p7zip

      # printing GUI (besides KDE's own print-manager)
      system-config-printer
    ];
  };

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--no-default-browser-check"
    ];
  };

  programs.home-manager.enable = true;
}
