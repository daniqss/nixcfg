{username, ...}: {
  imports = [
    ../../home/${username}
  ];

  graphical = {
    enable = true;
    gaming.enable = false;

    emulators = {
      emulator = "ghostty";
      fontsize = 13;
    };

    desktops = {
      desktop = "hyprland";
      monitors = [
        {
          name = "eDP-1";
          resolution = {
            x = 1920;
            y = 1080;
          };
          refresh = "60.0";
          position = {
            x = 0;
            y = 0;
          };
          scale = "1.0";
        }
      ];
      hyprland.hyprqtile.enable = false;
    };
  };

  dev.enable = true;
  terminal.enable = true;
}
