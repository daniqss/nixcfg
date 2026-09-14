{
  inputs,
  outputs,
}: {
  inherit (import ./mk-configs.nix {inherit inputs outputs;}) mkNixos mkHome;
}
