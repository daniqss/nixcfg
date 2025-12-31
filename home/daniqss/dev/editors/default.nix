{
  pkgs,
  config,
  lib,
  ...
}: let
in {
  imports = [
    ./vscode.nix
  ];

  home.packages = lib.mkIf (config.dev.enable && config.graphical.enable) [
    pkgs.gemini-cli
  ];
}
