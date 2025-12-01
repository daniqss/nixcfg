{
  description = "one configuration to rule them all";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

    matugen = {
      url = "github:/InioX/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprqtile = {
      url = "github:daniqss/hyprqtile";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pinnacle.url = "github:pinnacle-comp/pinnacle";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs {pkgs = import nixpkgs {inherit system;};});
    overlays = import ./overlays {inherit inputs outputs;};
    templates = import ./templates {inherit inputs outputs;};
    nixosConfigurations = import ./hosts {inherit inputs outputs;};
  };
}
