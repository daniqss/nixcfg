{
  description = "my nixos configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      hp887A = lib.nixosSystem {
        inherit system;
        modules = [./configuration.nix];
      };
    };

    packages.${system}.rebuild = pkgs.writeScriptBin "rebuild" ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.alejandra}/bin/alejandra . &>/dev/null
      ${pkgs.git}/bin/git diff -U0 *.nix
      echo "NixOS Rebuilding..."
      ${pkgs.sudo}/bin/sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch &>nixos-switch.log || (
        ${pkgs.coreutils}/bin/cat nixos-switch.log | ${pkgs.gnugrep}/bin/grep --color error && false)
      gen=$(${pkgs.nixos-rebuild}/bin/nixos-rebuild list-generations | ${pkgs.gnugrep}/bin/grep current)
      ${pkgs.git}/bin/git commit -am "$gen"
    '';

    defaultPackage.${system} = self.packages.${system}.rebuild;
  };
}
