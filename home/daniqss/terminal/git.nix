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

  forgeModule = {
    options = {
      host = mkOption {
        type = types.str;
        example = "gitlab.udc.es";
        description = "hostname of the forge accessed via ssh";
      };

      user = mkOption {
        type = types.str;
        default = "git";
        description = "ssh user used to authenticate against the forge";
      };

      port = mkOption {
        type = types.nullOr types.port;
        default = null;
        description = "ssh port of the forge, null to use the default one";
      };

      identityFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "~/.ssh/gitlab_ed25519";
        description = "ssh key used for this forge, null to let ssh pick it";
      };

      rewriteHttps = mkOption {
        type = types.bool;
        default = true;
        description = "rewrite https urls of this forge to ssh";
      };
    };
  };

  mkForgeSsh = forge: {
    ${forge.host} =
      {
        User = forge.user;
        HostName = forge.host;
      }
      // optionalAttrs (forge.port != null) {
        Port = forge.port;
      }
      // optionalAttrs (forge.identityFile != null) {
        IdentityFile = forge.identityFile;
        IdentitiesOnly = true;
      };
  };

  forgeSshSettings = lib.mergeAttrsList (map mkForgeSsh cfg.forges);

  forgeGitUrls = lib.listToAttrs (
    map (forge:
      lib.nameValuePair "${forge.user}@${forge.host}:" {
        insteadOf = "https://${forge.host}/";
      })
    (lib.filter (forge: forge.rewriteHttps) cfg.forges)
  );
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

        forges = mkOption {
          type = types.listOf (types.submodule forgeModule);
          default = [];
          example = [
            {
              host = "gitlab.freedesktop.org";
              identityFile = "~/.ssh/gitlab_ed25519";
            }
            {
              host = "git.example.org";
              port = 2222;
            }
          ];
          description = "git forges accessed via ssh, each one gets an ssh host entry and an https to ssh url rewrite";
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
        // forgeSshSettings
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
          url = forgeGitUrls;
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
