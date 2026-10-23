{pkgs, ...}: {
  terminal.enable = true;
  dev.editors.helix.enable = true;

  graphical = {
    emulators.enable = true;
    flatpak.enable = false;
  };

  fonts.fontconfig.enable = true;
  home.packages = [pkgs.nerd-fonts.caskaydia-cove];
}
