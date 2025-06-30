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

  options.dev.enable = lib.mkEnableOption "enable editors and langs";
}
