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

      chromium
      google-chrome

      blueberry
      pavucontrol

      nautilus
      nautilus-open-any-terminal

      spotify
      (discord.override {withVencord = true;})

      nerd-fonts.caskaydia-cove
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      noto-fonts-color-emoji
    ];

    fonts.fontconfig.enable = true;
  };
}
