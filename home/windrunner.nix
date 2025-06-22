{username, ...}: {
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  imports = [
    ./desktop
    ./dev
    ./terminal
  ];

  desktop = {
    enable = true;
    hyprland.enable = true;
  };
  dev.enable = true;
  terminal.enable = true;

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1,1920x1080@60.06,0x0, 1.0"
      "HDMI-A-1,1920x1080@60.06,0x0,1.0,mirror, eDP-1"
    ];

    device = {
      name = "elan071a:00-04f3:30fd-touchpad";
      sensitivity = 0.1;
    };
  };
}
