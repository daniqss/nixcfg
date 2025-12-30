{
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
      package = pkgs.immich.override {
        valkey = pkgs.valkey.overrideAttrs (_: {
          doCheck = false;
        });
      };
      database = {
	enableVectors = false;
	enableVectorChoad = false;
      };
    };

    users.users.immich.extraGroups = ["video" "render"];
  };
}
