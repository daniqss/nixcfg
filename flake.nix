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
    nixpkgs,
    home-manager,
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

    homeConfigurations = {
      daniqss = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home.nix];
      };
    };
  };
}
