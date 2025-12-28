{
  config,
  lib,
  ...
}: {
  imports = [
    ./minecraft.nix
    ./immich.nix
  ];

  options.server.enable = lib.mkEnableOption "enable server profile";

  config = lib.mkIf config.server.enable {
    server.immich.enable = lib.mkDefault true;
    server.minecraft.enable = lib.mkDefault true;
  };
}
