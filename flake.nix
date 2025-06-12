{
  description = "my nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let 
      system = "x86_64-linux";
      

        config = {
          allowUnfree = true;
        };      pkgs = import nixpkgs {
        inherit system;

      };
    in
    {
    nixosConfigurations = {
      nixcfg = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };

        modules = [
          ./nixcfg/configuration.nix
        ];
      };
    };
  };
}
