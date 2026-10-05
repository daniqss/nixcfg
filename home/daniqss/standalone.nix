{
  inputs,
  outputs,
  flakeDir,
  pkgs,
  lib,
  config,
  ...
}: {
  # things the nixos profiles provide at system level and that the work distro won't
  config = lib.mkIf (!config.platform.isNixOS) {
    programs.home-manager.enable = true;

    targets.genericLinux.enable = true;

    nix = {
      package = pkgs.nix;
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      settings = outputs.lib.nixSettings;
    };

    programs.direnv = {
      enable = true;
      silent = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    home.packages = [pkgs.nh];

    home.sessionVariables = {
      NH_FLAKE = flakeDir;
    };
  };
}
