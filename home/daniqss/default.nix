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
}
