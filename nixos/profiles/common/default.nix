{...}: {
  imports = [
    ./network.nix
    ./nix.nix
    ./tailscale.nix
    ./qemu.nix
    ./keys.nix
  ];
}
