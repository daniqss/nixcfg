{
  config,
  lib,
  ...
}: let
  domain = "${config.networking.hostName}.tailb76493.ts.net";
  certPath = "/var/lib/tailscale/certs/${domain}.crt";
  keyPath = "/var/lib/tailscale/certs/${domain}.key";
in {
  options.server.caddy = {
    enable = lib.mkEnableOption "enable Caddy with Tailscale certs";
  };

  config = lib.mkIf config.server.caddy.enable {
    services.caddy = {
      enable = true;
      virtualHosts."${domain}" = {
        extraConfig = ''
          tls ${certPath} ${keyPath}
          
          ${lib.optionalString config.server.immich.enable ''
            handle /immich* {
              reverse_proxy http://[::1]:${toString config.services.immich.port}
            }
            # Catch all for immich at root
            reverse_proxy http://[::1]:${toString config.services.immich.port}
          ''}
        '';
      };
    };

    networking.firewall.allowedTCPPorts = [80 443];
  };
}
