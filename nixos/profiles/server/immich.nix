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
