{username, ...}: {
  imports = [
    ../../home/${username}
  ];

  graphical.enable = false;
  dev.enable = true;
  terminal = {
    enable = true;
    terminfo.enable = true;
  };
}
