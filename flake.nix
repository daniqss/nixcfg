{
  description = "my nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    # inherit (self) outputs;
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      bondsmith = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit system inputs;};

        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
