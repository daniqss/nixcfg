{
  isNixOS,
  username,
  flakeDir,
  lib,
  pkgs,
  config,
  ...
}: {
  options.platform = {
    isNixOS = lib.mkOption {
      type = lib.types.bool;
      default = isNixOS;
      description = ''
        whether this home configuration is evaluated as a nixos module or as a
        standalone home-manager configuration on a foreign distro
      '';
    };

    autoCloneFlake = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "clone the nixcfg repo into flakeDir during activation if missing";
    };
  };

  config = {
    home = {
      inherit username;
      homeDirectory = "/home/${username}";

      stateVersion = "26.11";

      # some parts of the configuration are symlinked to the nixcfg repo
      # so to achieve actual reproducibility we need to make sure it's cloned before any of those parts are evaluated
      activation.cloneNixcfg = lib.mkIf config.platform.autoCloneFlake (lib.hm.dag.entryBefore ["checkLinkTargets"] ''
        if [ ! -d "${flakeDir}" ]; then
          ${lib.getExe' pkgs.git "git"} clone https://github.com/${username}/nixcfg "${flakeDir}"
        fi
      '');
    };
  };

  imports = [
    ./standalone.nix
    ./graphical
    ./dev
    ./terminal
  ];
}
