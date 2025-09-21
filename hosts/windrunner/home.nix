{
  username,
  pkgs,
  ...
}: {
  imports = [
    ../../home/${username}
  ];

  graphical = {
    enable = true;
    gaming.enable = false;
    emulators = {
      emulator = pkgs.ghostty;
      fontsize = 13;
    };
    hyprland.hyprqtile.enable = false;
  };
  dev.enable = true;
  terminal.enable = true;
}
