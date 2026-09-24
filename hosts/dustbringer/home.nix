{lib, ...}: {
  terminal = {
    enable = true;

    # better to use zsh from ubuntu packages
    shell.zsh.package = null;

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

    browsers.enable = false;
    desktops.desktop = lib.mkForce "none";
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
