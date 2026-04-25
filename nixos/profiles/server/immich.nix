{
  config,
  pkgs,
  lib,
  ...
}: {
  options.server.immich.enable = lib.mkEnableOption "enable Immich server";

  config = lib.mkIf config.server.immich.enable {
    environment.systemPackages = with pkgs; [
      immich-cli
    ];

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

      accelerationDevices = null;
    };

    services.caddy = {
      enable = true;
      virtualHosts."immich.example.com".extraConfig = ''
        reverse_proxy http://[::1]:${toString config.services.immich.port}
      '';
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    users.users.immich.extraGroups = ["video" "render"];
  };
}
