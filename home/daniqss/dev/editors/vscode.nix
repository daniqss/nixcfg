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
            name = "remote-ssh-edit";
            publisher = "ms-vscode-remote";
            version = "0.47.2";
            sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
          }
          {
            name = "qt-qml";
            publisher = "TheQtCompany";
            version = "1.5.1";
            sha256 = "sha256-l19OW4lJR8+SxHeLvRzBGtxC+y5seNdOz9jnlK9HDkQ=";
          }
          {
            name = "qt-core";
            publisher = "TheQtCompany";
            version = "1.5.1";
            sha256 = "sha256-0I41cw809oeL5n78TkNKJ+YdFBu237vaNBZuWv3xKn8=";
          }
        ];

      profiles.default.userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
    };
  };
}
