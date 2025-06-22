{username, ...}: {
  imports = [./${username}];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  wayland.windowManager.hyprland = {
    monitors = [
      "DP-1,1920x1080@143.85,0x0,1.0"
    ];
  };
}
