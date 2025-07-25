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

      spotify
      (discord.override {withVencord = true;})

      qbittorrent

      nerd-fonts.caskaydia-cove
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
    ];

    fonts.fontconfig.enable = true;

    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "auto";
    };
  };
}
