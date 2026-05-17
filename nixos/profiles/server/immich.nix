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
      immich # for immich-admin
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
