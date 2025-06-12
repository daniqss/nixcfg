{
  description = "my nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    config = {
      allowUnfree = true;
    };
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    nixosConfigurations = {
      bondsmith = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit system inputs;};

        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
