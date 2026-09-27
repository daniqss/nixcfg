{
  description = "one configuration to rule them all";

  # shared with the built system: nixos/profiles/common/nix.nix reads this same
  # attribute back. It has to stay a literal attrset, nix refuses a thunk here,
  # so it cannot be moved out into its own file
  nixConfig.extra-experimental-features = ["nix-command" "flakes" "pipe-operators"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };

    nvf.url = "github:NotAShelf/nvf";

    nixcraft = {
      url = "github:daniqss/nixcraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    vicinae.url = "github:vicinaehq/vicinae";
    vicinae-extensions.url = "github:vicinaehq/extensions";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nix-minecraft.url = "github:daniqss/nix-minecraft";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    inherit (self) outputs;

    eachSystem = f:
      nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"]
      (system: f system (import nixpkgs {inherit system;}));

    treefmtEval = eachSystem (_system: pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    packages = eachSystem (_system: pkgs: import ./pkgs {inherit pkgs;});
    devShells = eachSystem (_system: pkgs: import ./devshells {inherit pkgs;});

    formatter = eachSystem (system: _pkgs: treefmtEval.${system}.config.build.wrapper);
    checks = eachSystem (system: _pkgs: {formatting = treefmtEval.${system}.config.build.check self;});

    lib = import ./lib {inherit inputs outputs;};

    overlays = import ./overlays {inherit inputs outputs;};
    templates = import ./templates {inherit inputs outputs;};
    nixosConfigurations = import ./hosts {inherit inputs outputs;};
    homeConfigurations = import ./home {inherit outputs;};
  };
}
