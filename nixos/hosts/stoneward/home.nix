{...}: let
  monitors = [
    {
      name = "DP-1";
      resolution = {
        x = 1920;
        y = 1080;
      };
      refresh = "143.85";
      position = {
        x = 0;
        y = 0;
      };
      scale = "1.0";
    }
    {
      name = "HDMI-A-1";
      resolution = {
        x = 1920;
        y = 1080;
      };
      refresh = "60.0";
      position = {
        x = 1920;
        y = 0;
      };
      scale = "1.0";
    }
  ];
in {
  graphical = {
    enable = true;
    gaming.enable = true;
    emulators = {
      emulator = "ghostty";
      fontsize = 12;
    };

    desktops = {
      desktop = "hyprland";
      monitors = monitors;
      hyprland.hyprqtile.enable =
        if (builtins.length monitors > 1)
        then true
        else false;
    };
  };
  dev.enable = true;
  terminal.enable = true;
}
