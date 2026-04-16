{
  lib,
  config,
  ...
}: let
  cfg = config.dev;
in {
  imports = [
    ./langs
    ./editors
  ];

  options.dev.enable = lib.mkEnableOption "enable editors and langs";

  config = lib.mkIf cfg.enable {
    dev.editors.vscode.enable = lib.mkDefault true;
    dev.editors.helix.enable = lib.mkDefault true;
  };
}
