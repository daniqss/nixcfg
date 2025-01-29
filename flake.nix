{
  description = "my nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    username = "daniqss";
  in {
    nixosConfigurations = {
      hp887A = lib.nixosSystem {
        inherit system;
        modules = [./configuration.nix];
        specialArgs = {
          inherit username;
        };
      };
    };

    homeConfigurations = {
      daniqss = home-manager.lib.homeManagerConfiguration {
        inherit system;
        inherit pkgs;
        modules = [./home.nix];
      };
    };

    packages.${system}.rebuild = pkgs.writeScriptBin "rebuild" ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.alejandra}/bin/alejandra . &>/dev/null
      ${pkgs.git}/bin/git diff -U0 *.nix
      echo "NixOS Rebuilding..."
      ${pkgs.sudo}/bin/sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake . &>nixos-switch.log || (
        ${pkgs.coreutils}/bin/cat nixos-switch.log | ${pkgs.gnugrep}/bin/grep --color error && false)
      echo "Running home-manager switch..."
      ${pkgs.home-manager}/bin/home-manager switch --flake . &>home-manager-switch.log || (
        ${pkgs.coreutils}/bin/cat home-manager-switch.log | ${pkgs.gnugrep}/bin/grep --color error && false)
      gen=$(${pkgs.nixos-rebuild}/bin/nixos-rebuild list-generations | ${pkgs.gnugrep}/bin/grep current)
      ${pkgs.git}/bin/git commit -am "$gen"
    '';

    defaultPackage.${system} = self.packages.${system}.rebuild;
  };
}
