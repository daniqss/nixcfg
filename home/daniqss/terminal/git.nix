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

        "bondsmith" = {
          user = "daniqss";
          hostname = "192.168.0.170";
        };
      };
    };

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = username;
          email = "danielqueijo14@gmail.com";
        };

        init.defaultBranch = "main";
        core.editor = "nvim";
        push.default = "current";
        push.autoSetupRemote = true;
      };
    };
  };
}
