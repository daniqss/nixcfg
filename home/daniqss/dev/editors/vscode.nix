{
  username,
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

          # linters and formatters
          esbenp.prettier-vscode

          # langs
          jnoortheen.nix-ide
          astro-build.astro-vscode
          attilabuti.brainfuck-syntax
          ms-vscode.cpptools
          ms-vscode.cpptools-extension-pack
          llvm-vs-code-extensions.vscode-clangd
          ms-vscode.makefile-tools
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

          charliermarsh.ruff

          mechatroner.rainbow-csv
          bradlc.vscode-tailwindcss
          rust-lang.rust-analyzer
          tauri-apps.tauri-vscode

          bradlc.vscode-tailwindcss

          # envs
          mkhl.direnv
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
          {
            name = "qml-format";
            publisher = "delgan";
            version = "1.1.0";
            sha256 = "sha256-QOovj9loSWAgaBCwW3HBPD/Wr7GwVppSRcCJ4R5X/as=";
          }
          {
            name = "ty";
            publisher = "astral-sh";
            version = "2025.43.12620731";
            sha256 = "sha256-XgBzwebFnhWZfZ914w1ppEtO4qZeOy+qRSCbmEQOP7k=";
          }
        ];
    };
    xdg.configFile."Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/nixcfg/home/daniqss/dev/editors/settings.json";
  };
}
