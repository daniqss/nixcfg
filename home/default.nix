{username, ...}: {
  imports = [
    ./terminal
    ./desktop
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };
}
