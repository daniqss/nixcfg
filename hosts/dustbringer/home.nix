{
  pkgs,
  lib,
  ...
}: {
  terminal = {
    enable = true;
    shell.default = pkgs.zsh;

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

    ssh = {
      homelab.enable = true;

      hosts.minipc-totem = {
        hostname = "10.1.0.158";
        user = "alen";
        identityFile = "~/.ssh/minipc_totem_ed25519";
      };
    };
  };

  dev = {
    enable = true;
    editors.emacs.enable = false;
    editors.nvim.enable = false;
  };

  # for now, until more testing
  graphical = {
    enable = true;

    browsers.enable = true;

    emulators.font.size = 12;

    desktops = {
      workspacesOnCurrentMonitor = true;

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
        {
          name = "HDMI-A-1";
          resolution = {
            x = 1920;
            y = 1080;
          };
          refresh = "60.0";
          position = {
            x = 1920;
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
