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
      # your settings need to go into the settings attribute set
      # most settings are documented in the appendix
      settings = {
        vim.viAlias = false;
        vim.vimAlias = true;
        vim.lsp = {
          enable = true;
        };
      };
    };
  };
}
