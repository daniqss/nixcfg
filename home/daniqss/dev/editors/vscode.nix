{
  pkgs,
  lib,
  config,
  ...
}: {
  options.vscode.enable = lib.mkEnableOption "Enable vscode editor module";

  config = lib.mkIf config.vscode.enable {
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
  };
}
