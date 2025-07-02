{
  lib,
  config,
  ...
}: {
  options.server.minecraft.enable = lib.mkEnableOption "enable minecraft java server";

  config = lib.mkIf config.server.minecraft.enable {
    services.minecraft-server = {
      enable = false;
      eula = true;
      openFirewall = true;
    };
  };
}
