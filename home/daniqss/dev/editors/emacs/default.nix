{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  # actually doom emacs but idk
  cfg = config.dev.editors.emacs;
in {
  imports = [
    inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  options.dev.editors.emacs.enable = mkEnableOption "enable doom emacs";

  config = mkIf cfg.enable {
    programs.doom-emacs = {
      enable = true;
    };
  };
}
