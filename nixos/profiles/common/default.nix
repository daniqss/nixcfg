{...}: {
  imports = [
    ./network.nix
    ./nix.nix
    ./tailscale.nix
    ./qemu.nix
    ./gpg.nix
    ./syncthing.nix
  ];
}
