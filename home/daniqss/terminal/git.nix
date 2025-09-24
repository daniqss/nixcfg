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
      };
    };

    programs.git = {
      enable = true;
      userName = username;
      userEmail = "danielqueijo14@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
        push.default = "current";
        push.autoSetupRemote = true;
      };
    };
  };
}
