{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.dev.enable
    && config.graphical.enable) {
    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions;
        [
          # theming
          pkief.material-icon-theme
          zhuangtongfa.material-theme

          # langs
          jnoortheen.nix-ide

          # envs
          mkhl.direnv
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "qt-qml";
            publisher = "TheQtCompany";
            version = "1.5.1";
            sha256 = "sha256-l19OW4lJR8+SxHeLvRzBGtxC+y5seNdOz9jnlK9HDkQ=";
          }
        ];

      profiles.default.userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
    };
  };
}
