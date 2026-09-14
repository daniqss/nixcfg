{
  pkgs,
  lib,
  config,
  ...
}: let
  personal = lib.optionals config.graphical.personal.enable;
in {
  options.graphical.personal.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "personal";
  };

  config = lib.mkIf config.graphical.enable {
    home.packages = with pkgs;
      [
        gnome-calculator
        gnome-disk-utility

        blueman
        pwvucontrol

        nautilus
        nautilus-open-any-terminal
        loupe

        obsidian
      ]
      ++ personal [
        (discord.override {withVencord = true;})
        spotify

        qbittorrent
      ]
      ++ [
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
      ]
      ++ personal [
        stable.aseprite
      ];

    fonts.fontconfig.enable = true;

    services.flatpak.packages = lib.mkIf config.graphical.flatpak.enable [
      {
        appId = "app.fotema.Fotema";
        origin = "flathub";
      }
    ];
  };
}
