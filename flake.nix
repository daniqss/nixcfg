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
    # inherit (self) outputs;
    system = "x86_64-linux";
    # pkgs = nixpkgs.legacy.${system};
  in {
    nixosConfigurations = {
      stoneward = nixpkgs.lib.nixosSystem {
        inherit system inputs;

        modules = [./configuration.nix];
      };
    };

    homeConfigurations = {
      daniqss = home-manager.lib.homeManagerConfiguration {
        inherit system inputs;

        modules = ["./home.nix"];
      };
    };
  };
}
