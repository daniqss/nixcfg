{
  config,
  pkgs,
  lib,
  ...
}: {
  options.server.immich.enable = lib.mkEnableOption "enable Immich server";

  config = lib.mkIf config.server.immich.enable {
    server.postgresql.enable = lib.mkDefault true;

    # for immich-admin
    environment.systemPackages = [
      pkgs.immich-cli
      pkgs.immich
    ];

    # photos.<domain> needs the caddy root ca on the other hosts, see caddy.nix
    server.caddy = let
      upstream = "http://${config.services.immich.host}:${toString config.services.immich.port}";
    in {
      proxies.photos = {inherit upstream;};

      # the phone can't resolve nor trust photos.<domain>, so the immich app
      # uses the bare domain with the tailscale certificate
      root = lib.mkDefault upstream;
    };

    services.immich = {
      enable = true;
      package = pkgs.immich;
      host = "127.0.0.1";
      port = 2283;
      openFirewall = false;

      accelerationDevices = null;
    };

    users.users.immich.extraGroups = ["video" "render"];
  };
}
