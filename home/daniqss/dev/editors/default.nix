{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./vscode.nix
    ./helix.nix
  ];

  home.packages = lib.mkIf (config.dev.enable && config.graphical.enable) [
    pkgs.unstable.opencode
    pkgs.unstable.gemini-cli
  ];
}
