{
  config,
  lib,
  ...
}: {
  options.desktop.gaming.enable = lib.mkEnableOption "enable gaming";

  config = lib.mkIf config.desktop.gaming.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
