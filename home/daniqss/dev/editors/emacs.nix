{
  inputs,
  lib,
  config,
  ...
}: let
  # actually doom emacs but idk
  cfg = config.dev.editors.emacs;
in {
  imports = [
    inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  options.dev.editors.emacs.enable = lib.mkEnableOption "enable doom emacs";

  config = lib.mkIf cfg.enable {
    programs.doom-emacs = {
      enable = true;
    };
  };
}
