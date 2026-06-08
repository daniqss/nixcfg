{
  username,
  lib,
  nixosConfig,
  config,
  ...
}: {
  config = lib.mkIf config.terminal.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {
          Compression = true;
        };

        "github.com" = {
          User = "git";
          HostName = "github.com";
          IdentityFile = "~/.ssh/github_ed25519";
          IdentitiesOnly = true;
        };

        "bondsmith-lan" = {
          User = "daniqss";
          HostName = "192.168.1.170";
        };

        "bondsmith" = {
          User = "daniqss";
          HostName = "bondsmith.tailb76493.ts.net";
        };
      };
    };

    programs.git = {
      enable = true;
      signing = lib.mkIf nixosConfig.common.gpg.enable {
        key = "33B0B872CC87EB05C27E7251B0B76101F06F56D7";
        signByDefault = true;
      };

      settings = {
        user = {
          name = username;
          email = "danielqueijo14@gmail.com";
        };

        init.defaultBranch = "main";
        core.editor = "hx";
        push.default = "current";
        push.autoSetupRemote = true;
      };
    };
  };
}
