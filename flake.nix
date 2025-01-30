{
  description = "my nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      hp887A = lib.nixosSystem {
        specialArgs = {inherit inputs system;};
        modules = [./configuration.nix];
      };
    };

    # homeConfigurations = {
    #   daniqss = home-manager.lib.homeManagerConfiguration {
    #     inherit pkgs;
    #     # inherit inputs;
    #     modules = [./home.nix];
    #     # specialArgs = {inherit inputs;};
    #   };
    # };
  };
}
