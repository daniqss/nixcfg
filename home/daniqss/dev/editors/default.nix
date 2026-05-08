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

  home.packages =
    lib.mkIf (config.dev.enable && config.graphical.enable)
    (with pkgs; [
      opencode
      gemini-cli
      claude-code
    ]);
}
