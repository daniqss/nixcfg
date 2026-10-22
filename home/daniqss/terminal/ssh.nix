{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkIf optionalAttrs types;
  cfg = config.terminal.ssh;

  hostModule = {
    options = {
      hostname = mkOption {
        type = types.str;
        example = "10.1.0.158";
        description = "address used to reach the host";
      };

      user = mkOption {
        type = types.str;
        example = "daniqss";
        description = "ssh user used to authenticate against the host";
      };

      port = mkOption {
        type = types.nullOr types.port;
        default = null;
        description = "ssh port of the host, null to use the default one";
      };

      identityFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "~/.ssh/id_ed25519";
        description = "ssh key used for this host, null to let ssh pick it";
      };
    };
  };

  mkHost = name: host: {
    ${name} =
      {
        User = host.user;
        HostName = host.hostname;
      }
      // optionalAttrs (host.port != null) {
        Port = host.port;
      }
      // optionalAttrs (host.identityFile != null) {
        IdentityFile = host.identityFile;
        IdentitiesOnly = true;
      };
  };

  hostsSettings = lib.mergeAttrsList (lib.mapAttrsToList mkHost cfg.hosts);
in {
  options.terminal.ssh = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "manage the ssh client configuration";
    };

    homelab.enable = mkOption {
      type = types.bool;
      default = true;
      description = "add the homelab hosts to the ssh config";
    };

    hosts = mkOption {
      type = types.attrsOf (types.submodule hostModule);
      default = {};
      example = {
        minipc-totem = {
          hostname = "10.1.0.158";
          user = "alen";
        };
      };
      description = "extra ssh hosts, each one gets an ssh host entry";
    };
  };

  config = mkIf (config.terminal.enable && cfg.enable) {
    terminal.ssh.hosts = optionalAttrs cfg.homelab.enable {
      bondsmith-lan = {
        hostname = "192.168.1.170";
        user = "daniqss";
      };

      bondsmith = {
        hostname = "bondsmith.tailb76493.ts.net";
        user = "daniqss";
      };
    };

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
        // hostsSettings;
    };
  };
}
