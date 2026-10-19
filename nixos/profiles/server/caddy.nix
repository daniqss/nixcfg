{
  hostname,
  config,
  lib,
  ...
}: let
  cfg = config.server.caddy;
in {
  options.server.caddy = {
    enable = lib.mkEnableOption "enable Caddy";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "${hostname}.tailb76493.ts.net";
      description = "tailscale magicdns name of the machine";
    };

    # setting up a new server
    # 1. set it to the server's `tailscale ip -4`
    # 2. switch it, caddy creates its root ca on the first start
    # 3. copy the root cert to the repo and track it, flakes ignore untracked files
    #    sudo cat /var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt > hosts/<host>/caddy-root.crt
    #    git add hosts/<host>/caddy-root.crt
    # 4. switch every host, the server included, so they trust it
    address = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "tailscale ip the other machines resolve the service subdomains to";
    };

    root = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "upstream served at the bare domain with the tailscale certificate";
    };

    # see lib/homelab.nix for why the subdomains need the caddy internal ca
    proxies = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.upstream = lib.mkOption {
          type = lib.types.str;
          description = "address caddy forwards the requests to";
        };
      });
      default = {};
      description = "services reverse proxied at <name>.<domain>";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;

      # the root ca is trusted through lib/homelab.nix, not by caddy itself
      globalConfig = ''
        skip_install_trust
      '';

      virtualHosts =
        (cfg.proxies
          |> lib.mapAttrs' (service: proxy:
            lib.nameValuePair "${service}.${cfg.domain}" {
              extraConfig = ''
                tls internal
                reverse_proxy ${proxy.upstream}
              '';
            }))
        // lib.optionalAttrs (cfg.root != null) {
          ${cfg.domain}.extraConfig = ''
            tls {
              get_certificate tailscale
            }

            reverse_proxy ${cfg.root}
          '';
        };
    };

    systemd.services.caddy .serviceConfig.Group = "caddy";

    # only reachable through tailscale, the certs are useless anywhere else
    networking.firewall.interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts = [443];
  };
}
