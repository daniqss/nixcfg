{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.graphical.enable {
    home.packages = with pkgs; [
      gnome-calculator
      gnome-disk-utility

      blueman
      pwvucontrol

      nautilus
      nautilus-open-any-terminal
      loupe

      obsidian
      (discord.override {withVencord = true;})
      spotify

      qbittorrent
      libreoffice

      nerd-fonts.caskaydia-cove
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      noto-fonts-color-emoji
      noto-fonts-cjk-serif

      alsa-utils
      playerctl
      brightnessctl
      cliphist
      wl-clipboard

      wireguard-tools

      dirlock
    ];

    fonts.fontconfig.enable = true;

    services.flatpak.packages = [
      {
        appId = "app.fotema.Fotema";
        origin = "flathub";
      }
    ];
  };
}
