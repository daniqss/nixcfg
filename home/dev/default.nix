{
  lib,
  config,
  ...
}: let
in {
  imports = [
    ./langs
    ./editors
  ];

  options.dev.enable = lib.mkEnableOption "enable editors";

  config = lib.mkIf config.dev.enable {
    vscode.enable = lib.mkDefault true;
  };
}
