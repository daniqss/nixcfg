{
  username,
  lib,
  config,
  ...
}: let
in {
  config = lib.mkIf config.terminal.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          compression = true;
        };

        "github.com" = {
          user = "git";
          hostname = "github.com";
          identityFile = "~/.ssh/github_ed25519";
          identitiesOnly = true;
        };

        "bondsmith-lan" = {
          user = "daniqss";
          hostname = "192.168.1.170";
        };

        "bondsmith" = {
          user = "daniqss";
          hostname = "bondsmith.tailb76493.ts.net";
        };
      };
    };

    programs.git = {
      enable = true;
      signing = {
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
