{
  pkgs,
  lib,
  config,
  ...
}: {
  options.terminal.terminfo.enable = lib.mkEnableOption "enable terminal terminfo";

  config = lib.mkIf config.terminal.terminfo.enable {
    home.packages = with pkgs; [
      ghostty.terminfo
    ];
  };
}
