{
  lib,
  config,
  ...
}: let
in {
  options.dev.enable = lib.mkEnableOption "enable editors";

  config = lib.mkIf config.dev.enable {
    vscode.enable = lib.mkDefault true;

    imports = [
      ./langs
      ./editors
    ];
  };
}
