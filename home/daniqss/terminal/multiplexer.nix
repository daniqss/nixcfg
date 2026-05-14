{
  config,
  lib,
  ...
}: {
  options.terminal.multiplexer.zellij.enable = lib.mkEnableOption "zellij with SSH auto-attach";

  config = lib.mkIf config.terminal.multiplexer.zellij.enable {
    programs.zellij.enable = true;
  };
}
