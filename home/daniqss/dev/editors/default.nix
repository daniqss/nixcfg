{pkgs, ...}: let
in {
  imports = [
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    gemini-cli
  ];
}
