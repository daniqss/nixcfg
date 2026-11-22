_: {
  graphical = {
    enable = true;

    desktops = {
      layouts = ["us" "es"];

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
        {
          name = "HDMI-A-1";
          resolution = {
            x = 1920;
            y = 1080;
          };
          refresh = "60.06";
          position = {
            x = 0;
            y = 0;
          };
          scale = "1.0";
          mirror = "eDP-1";
        }
      ];
    };

    gaming = {
      enable = true;

      minecraft.options = {
        "key_key.hotbar.1" = "key.keyboard.1";
        "key_key.hotbar.2" = "key.keyboard.2";
        maxFps = 60;
      };
    };
  };

  dev.enable = true;
  terminal.enable = true;
}
