{
  isLaptop,
  lib,
  config,
  ...
}: let
  ttlCache =
    if isLaptop
    then 3600
    else 43200;
in {
  options.common.gpg.enable = lib.mkEnableOption "enable gpg agent with ssh support";

  config = lib.mkIf config.common.gpg.enable {
    programs.gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;

        settings = {
          default-cache-ttl = ttlCache;
          max-cache-ttl = ttlCache;
        };
      };
    };
  };
}
