{
  inputs,
  outputs,
}: {
  inherit (import ./mk-configs.nix {inherit inputs outputs;}) mkNixos mkHome;
  inherit (import ./options.nix {inherit (inputs.nixpkgs) lib;}) packageEnum mkProgramGroupOptions mkProgramEnableOption mkFontOptions;

  mkMinecraft = import ./mk-minecraft.nix;
  minecraft = import ./minecraft.nix;

  nixSettings = import ./nix-settings.nix;

  homelab = import ./homelab.nix {inherit inputs outputs;};
}
