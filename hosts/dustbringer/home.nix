{lib, ...}: {
  terminal = {
    enable = true;
    shell.default = "zsh";

    git = {
      email = "daniel.queijo@alen.space";
      personal.enable = true;
      forges = [
        {
          host = "gitlab.alen.space";
          identityFile = "~/.ssh/gitlab_ed25519";
        }
      ];
    };

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
    desktops = {
      desktop = lib.mkForce "hyprland";

      # without an explicit scale hyprland's "auto" picks 1.5 on this panel
      monitors = [
        {
          name = "eDP-1";
          resolution = {
            x = 1920;
            y = 1080;
          };
          refresh = "60.0";
          position = {
            x = 0;
            y = 0;
          };
          scale = "1.0";
        }
      ];
    };

    misc = {
      personal.enable = lib.mkForce false;
      work.enable = lib.mkForce true;
    };

    gaming.enable = false;
  };
}
