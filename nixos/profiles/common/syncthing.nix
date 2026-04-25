{
  config,
  lib,
  username,
  ...
}: {
  options.common.syncthing.enable = lib.mkEnableOption "enable Syncthing";

  config = lib.mkIf config.common.syncthing.enable {
    services.syncthing = {
      enable = true;
      user = username;
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;

      settings = {
        devices = {
          "bondsmith" = {id = "REPLACE-WITH-BONDSMITH-ID";};
          "skybreaker" = {id = "REPLACE-WITH-SKYBREAKER-ID";};
          "windrunner" = {id = "REPLACE-WITH-WINDRUNNER-ID";};
          "stoneward" = {id = "REPLACE-WITH-STONEWARD-ID";};
          "phone1" = {id = "REPLACE-WITH-MOBILE-ID";};
        };
        folders = {
          "sync" = {
            path = "/home/${username}/sync";
            devices = ["skybreaker" "windrunner" "stoneward" "phone1"];
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [22000];
    networking.firewall.allowedUDPPorts = [22000 21027];
  };
}
