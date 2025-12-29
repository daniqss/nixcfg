{
  pkgs,
  lib,
  config,
  ...
}: {
  options.server.terminfo.enable = lib.mkEnableOption "enable terminal terminfo";

  config = lib.mkIf config.server.terminfo.enable {
    environment.systemPackages = with pkgs; [
      ghostty.terminfo
    ];
  };
}
