{pkgs, ...}: {
  eduroam = import ./eduroam.nix {inherit pkgs;};
}
