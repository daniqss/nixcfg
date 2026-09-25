_: {
  imports = [
    ./vscode.nix
    ./emacs
    ./nvim
    ./helix.nix
  ];

  #   home.packages =
  #     lib.mkIf (config.dev.enable && config.graphical.enable)
  #     (with pkgs; [
  #       # opencode
  #       # gemini-cli
  #       # claude-code
  #     ]);
}
