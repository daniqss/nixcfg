{username, ...}: {
  imports = [
    ../../home/${username}
  ];

  graphical = {
    enable = true;
    gaming.enable = true;
  };
  dev.enable = true;
  terminal.enable = true;
}
