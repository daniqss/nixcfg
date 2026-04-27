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
      openFirewall = false;

      database = {
        enableVectors = false;
        enableVectorChord = true;
      };

      accelerationDevices = null;
    };

    users.users.immich.extraGroups = ["video" "render"];
  };
}
