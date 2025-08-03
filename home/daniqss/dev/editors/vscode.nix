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
      package = pkgs.vscode-fhs;

      profiles.default.extensions = with pkgs.vscode-extensions;
        [
          # theming
          pkief.material-icon-theme
          zhuangtongfa.material-theme

          # langs
          jnoortheen.nix-ide
          astro-build.astro-vscode
          attilabuti.brainfuck-syntax
          ms-vscode.cpptools
          ms-vscode.cpptools-extension-pack
          ms-azuretools.vscode-docker
          dbaeumer.vscode-eslint
          tamasfe.even-better-toml
          github.vscode-github-actions
          gleam.gleam
          golang.go
          ms-toolsai.jupyter
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.jupyter-renderers
          ms-toolsai.jupyter-keymap
          ms-toolsai.vscode-jupyter-slideshow
          yzane.markdown-pdf
          ocamllabs.ocaml-platform
          ms-python.python
          ms-python.debugpy
          ms-python.pylint
          mechatroner.rainbow-csv
          bradlc.vscode-tailwindcss
          rust-lang.rust-analyzer
          tauri-apps.tauri-vscode

          # envs
          # mkhl.direnv
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "qt-qml";
            publisher = "TheQtCompany";
            version = "1.7.0";
            sha256 = "sha256-QjfvZIcE4LcJU93YiYN/zykEluHtR7zVOwYiPL0k+cQ=";
          }
          {
            name = "qt-core";
            publisher = "TheQtCompany";
            version = "1.7.0";
            sha256 = "sha256-2413vMpvxSYBKpaD14sMgI92W8NtCYa/sJ7PZO62WfY=";
          }
        ];

      profiles.default.userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
    };
  };
}
