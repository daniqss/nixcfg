{username, ...}: {
  imports = [
    ./terminal
    ./desktop
    ./dev
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };
}
