{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  config = lib.mkIf config.graphical.enable {
    home.packages = with pkgs; [
      gnome-calculator
      gnome-disk-utility

      blueberry
      pwvucontrol

      nautilus
      nautilus-open-any-terminal
      loupe

      obsidian
      (discord.override {withVencord = true;})
      spotify

      qbittorrent

      nerd-fonts.caskaydia-cove
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
      noto-fonts-cjk-serif

      alsa-utils
      playerctl
      brightnessctl
      cliphist
      wl-clipboard
    ];

    fonts.fontconfig.enable = true;
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    services.flatpak.packages = [
      {
        appId = "app.fotema.Fotema";
        origin = "flathub";
      }
    ];
  };
}
