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
    hyprland.enable = true;
  };
  dev.enable = true;
  terminal.enable = true;

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-1,1920x1080@143.85,0x0,1.0"
    ];
  };
}
