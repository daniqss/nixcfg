{lib, ...}: {
  terminal = {
    enable = true;
    shell.default = "nushell";

    git.identity.email = "daniel.queijo@alen.space";

    ssh.homelab.enable = false;
  };

  dev = {
    enable = true;
    editors.emacs.enable = false;
  };

  # for now, until more testing
  graphical = {
    enable = true;

    browsers.enable = true;
    desktops.desktop = lib.mkForce "hyprland";
    misc = {
      personal.enable = lib.mkForce false;
      work.enable = lib.mkForce true;
    };

    shells = {
      vicinae.enable = false;
      quickshell.enable = false;
    };

    gaming.enable = false;
  };
}
