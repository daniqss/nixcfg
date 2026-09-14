{
  username,
  lib,
  config,
  ...
}: let
  cfg = config.terminal.git;
in {
  options.terminal = {
    git = {
      identity = {
        name = lib.mkOption {
          type = lib.types.str;
          default = username;
          description = "name used to author commits";
        };

        email = lib.mkOption {
          type = lib.types.str;
          default = "danielqueijo14@gmail.com";
          description = "email used to author commits";
        };
      };

      signing = {
        enable = lib.mkEnableOption "sign git commits by default";

        key = lib.mkOption {
          type = lib.types.str;
          default = "33B0B872CC87EB05C27E7251B0B76101F06F56D7";
          description = "gpg key used to sign commits";
        };
      };
    };

    ssh.homelab.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "add the homelab hosts to the ssh config";
    };
  };

  config = lib.mkIf config.terminal.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings =
        {
          "*" = {
            Compression = true;
          };

          "github.com" = {
            User = "git";
            HostName = "github.com";
            IdentityFile = "~/.ssh/github_ed25519";
            IdentitiesOnly = true;
          };
        }
        // lib.optionalAttrs config.terminal.ssh.homelab.enable {
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
      signing = lib.mkIf cfg.signing.enable {
        inherit (cfg.signing) key;
        signByDefault = true;
      };

      settings = {
        user = {
          inherit (cfg.identity) name email;
        };

        init.defaultBranch = "main";
        core.editor = "hx";
        push.default = "current";
        push.autoSetupRemote = true;
      };
    };
  };
}
