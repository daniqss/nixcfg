{...}: {
  imports = [
    ./network.nix
    ./nix.nix
    ./tailscale.nix
    ./binfmt.nix
    ./gpg.nix
    ./syncthing.nix
  ];
}
