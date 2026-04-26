{
  username,
  lib,
  pkgs,
  ...
}: {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    # some parts of the configuration are symlinked to the nixcfg repo
    # so to achieve actual reproducibility we need to make sure it's cloned before any of those parts are evaluated
    activation.cloneNixcfg = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      if [ ! -d "$HOME/nixcfg" ]; then
        ${lib.getExe' pkgs.git "git"} clone https://github.com/${username}/nixcfg "/home/${username}/nixcfg"
      fi
    '';
  };

  imports = [
    ./graphical
    ./dev
    ./terminal
  ];
}
