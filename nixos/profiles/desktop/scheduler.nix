{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.desktop.lavd;
in {
  options.desktop.lavd.enable = mkEnableOption "enable default desktop profile";

  config = mkIf cfg.enable {
    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
    };
  };
}
