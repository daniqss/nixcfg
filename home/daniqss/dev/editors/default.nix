{
  lib,
  config,
  pkgs,
  ...
}: let
in {
  imports = [
    ./vscode.nix
  ];

  home.packages = lib.mkIf (config.graphical.enable && config.dev.enable) [
    pkgs.gemini-cli
  ];
}
