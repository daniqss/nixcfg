{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # theming
      pkief.material-icon-theme
      zhuangtongfa.material-theme

      # langs
      jnoortheen.nix-ide
    ];

    profiles.default.userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
  };
}
