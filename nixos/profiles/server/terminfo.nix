{
  lib,
  config,
  ...
}: {
  options.server.terminfo.enable = lib.mkEnableOption "enable terminal terminfo";

  config = lib.mkIf config.server.terminfo.enable {
    environment.enableAllTerminfo = config.server.terminfo.enable;
  };
}
