{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkMerge;
  cfg = config.graphical.misc;
in {
  imports = [
    ./fonts.nix
  ];

  options.graphical.misc.enable = mkEnableOption "enable misc packages";
  options.graphical.misc.personal.enable = mkEnableOption "enable misc packages";
  options.graphical.misc.work.enable = mkEnableOption "enable misc packages";

  config = lib.mkIf cfg.enable {
    home.packages = mkMerge [
      # common
      (with pkgs; [
        gnome-calculator
        gnome-disk-utility

        blueman
        pwvucontrol

        nautilus
        nautilus-open-any-terminal

        libreoffice

        alsa-utils
        playerctl
        brightnessctl
        cliphist
        wl-clipboard

        spotify
      ])

      (mkIf cfg.personal.enable (with pkgs; [
        (discord.override {withVencord = true;})
        dirlock
        qbittorrent
        stable.aseprite
        obsidian
        loupe
      ]))

      (mkIf cfg.work.enable (with pkgs; [
        iio-oscilloscope
        tio
      ]))
    ];
  };
}
