{pkgs, ...}: {
  graphical = {
    enable = true;
    gaming = {
      enable = true;
      hollowknight.enable = true;
    };
    emulators.font.size = 12;

    desktops = {
      monitors = [
        {
          name = "DP-2";
          resolution = {
            x = 1920;
            y = 1080;
          };
          refresh = "143.85";
          # only in fullscreen, so the desktop doesn't flicker on idle refresh drops
          vrr = 2;
          position = {
            x = 0;
            y = 0;
          };
          scale = "1.0";
        }
        # {
        #   name = "HDMI-A-1";
        #   resolution = {
        #     x = 1920;
        #     y = 1080;
        #   };
        #   refresh = "60.0";
        #   position = {
        #     x = 1920;
        #     y = 0;
        #   };
        #   scale = "1.0";
        # }
      ];
    };
  };
  dev.enable = true;
  terminal = {
    enable = true;
    shell.default = pkgs.zsh;
  };
}
