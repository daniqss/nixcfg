{username, ...}: {
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  imports = [
    ./graphical
    ./dev
    ./terminal
  ];

  graphical = {
    enable = true;
  };
  dev.enable = true;
  terminal.enable = true;

  wayland.windowManager.hyprland.settings = {
    device = {
      name = "elan071a:00-04f3:30fd-touchpad";
      sensitivity = 0.1;
    };
  };
}
