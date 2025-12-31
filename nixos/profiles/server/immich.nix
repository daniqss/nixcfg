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
        enableVectorChord = true;
      };
    };

    services.immich-public-proxy = {
      enable = true;
      port = 2284;
      openFirewall = true;
      immichUrl = "http://immich";
    };

    users.users.immich.extraGroups = ["video" "render"];
  };
}
