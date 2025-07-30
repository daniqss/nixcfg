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
    gaming.enable = true;
    emulators = {
      emulator = pkgs.ghostty;
      fontsize = 13;
    };
    hyprland.hyprqtile.enable = true;
  };
  dev.enable = true;
  terminal.enable = true;
}
