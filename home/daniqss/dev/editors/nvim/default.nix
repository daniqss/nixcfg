{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dev.editors.nvim;
in {
  imports = [
    inputs.nvf.homeManagerModules.default
  ];

  options.dev.editors.nvim.enable = mkEnableOption "enables nvim as an editor";

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;

      settings.vim = {
        viAlias = false;
        vimAlias = true;

        globals.mapleader = " ";

        opts = {
          number = true;
          relativenumber = true;
          expandtab = true;
          shiftwidth = 2;
          tabstop = 2;
          scrolloff = 4;

          ignorecase = true;
          smartcase = true;
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };

        lsp = {
          enable = true;
          formatOnSave = true;
        };

        languages = {
          enableTreesitter = true;
          enableFormat = true;

          nix = {
            enable = true;
            lsp.servers = ["nixd"];
          };
          rust.enable = true;
          markdown.enable = true;
        };

        autocomplete.nvim-cmp.enable = true;

        telescope.enable = true;

        filetree.neo-tree.enable = true;
        keymaps = [
          {
            key = "<leader>e";
            mode = "n";
            action = "<cmd>Neotree toggle<cr>";
            desc = "Toggle file tree";
          }
        ];

        binds.whichKey.enable = true;

        statusline.lualine.enable = true;
        git.enable = true;
        comments.comment-nvim.enable = true;
        autopairs.nvim-autopairs.enable = true;
        visuals.nvim-web-devicons.enable = true;
      };
    };
  };
}
