{
  username,
  hmDir,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkIf optionalAttrs types;
  cfg = config.terminal.git;

  defaultName = username;
  defaultPersonalName = hmDir;
  defaultEmail = "danielqueijo14@gmail.com";
  defaultKey = "33B0B872CC87EB05C27E7251B0B76101F06F56D7";

  mkIdentityOptions = {
    name,
    email,
  }: {
    name = mkOption {
      type = types.str;
      default = name;
      description = "name used to author commits";
    };

    email = mkOption {
      type = types.str;
      default = email;
      description = "email used to author commits";
    };

    signing = {
      enable = mkEnableOption "signing commits with this identity";

      key = mkOption {
        type = types.str;
        default = defaultKey;
        description = "gpg key used to sign commits";
      };
    };
  };

  mkGitIdentity = {
    name,
    email,
    signingEnable,
    signingKey,
  }:
    {
      user =
        {
          inherit name email;
        }
        // optionalAttrs signingEnable {
          inherit signingKey;
        };
    }
    // optionalAttrs signingEnable {
      commit.gpgSign = true;
    };
in {
  options.terminal = {
    git =
      mkIdentityOptions {
        name = defaultName;
        email = defaultEmail;
      }
      // {
        personal =
          {
            enable = mkEnableOption "personal identity for repos under personal.dir";

            dir = mkOption {
              type = types.str;
              default = "~/personal/";
              description = "directory whose repos use the personal identity (keep the trailing slash)";
            };
          }
          // mkIdentityOptions {
            name = defaultPersonalName;
            email = defaultEmail;
          };
      };

    ssh.homelab.enable = mkOption {
      type = types.bool;
      default = true;
      description = "add the homelab hosts to the ssh config";
    };
  };

  config = mkIf config.terminal.enable {
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
        // optionalAttrs config.terminal.ssh.homelab.enable {
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

      settings =
        {
          init.defaultBranch = "main";
          core.editor = "hx";
          push.default = "current";
          push.autoSetupRemote = true;
        }
        // mkGitIdentity {
          inherit (cfg) name email;
          signingEnable = cfg.signing.enable;
          signingKey = cfg.signing.key;
        };

      includes = mkIf cfg.personal.enable [
        {
          condition = "gitdir:${cfg.personal.dir}";
          contents = mkGitIdentity {
            inherit (cfg.personal) name email;
            signingEnable = cfg.personal.signing.enable;
            signingKey = cfg.personal.signing.key;
          };
        }
      ];
    };
  };
}
