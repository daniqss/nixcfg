{
  pkgs,
  config,
  lib,
  ...
}: {
  options.server.immich.enable = lib.mkEnableOption "enable Immich server, doesn't work yet";

  config = lib.mkIf config.server.immich.enable {
    services.immich = {
      enable = true;
      port = 2283;
      openFirewall = true;
      database = {
        enableVectors = false;
        enableVectorChoad = true;
      };
    };

    users.users.immich.extraGroups = ["video" "render"];
  };
}
