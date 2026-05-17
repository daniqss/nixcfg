{
  hostname,
  config,
  lib,
  ...
}: let
  domain = "${hostname}.tailb76493.ts.net";
in {
  options.server.caddy = {
    enable = lib.mkEnableOption "enable Caddy";
  };

  config = lib.mkIf config.server.caddy.enable {
    services.caddy = {
      enable = true;
      virtualHosts."${domain}" = {
        extraConfig = ''
          tls {
            get_certificate tailscale
          }

          reverse_proxy http://127.0.0.1:${toString config.services.immich.port}
        '';
      };
    };

    systemd.services.caddy .serviceConfig.Group = "caddy";
    networking.firewall.allowedTCPPorts = [443];
  };
}
