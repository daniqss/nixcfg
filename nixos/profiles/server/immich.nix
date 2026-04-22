{
  config,
  pkgs,
  lib,
  ...
}: {
  options.server.immich.enable = lib.mkEnableOption "enable Immich server";

  config = lib.mkIf config.server.immich.enable {
    services.immich = {
      enable = true;
      package = pkgs.unstable.immich;
      port = 2283;

      host = "0.0.0.0";
      openFirewall = true;

      database = {
        enableVectors = false;
        enableVectorChord = true;
      };
    };

    services.nginx.virtualHosts."immich.example.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.immich.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';
      };
    };

    users.users.immich.extraGroups = ["video" "render"];
  };
}
