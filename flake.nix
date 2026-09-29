{
  description = "one configuration to rule them all";

  nixConfig = {
    extra-experimental-features = ["nix-command" "flakes" "pipe-operators"];

    extra-substituters = [
      "https://nvf.cachix.org"
      "https://doom-emacs-unstraightened.cachix.org"
      "https://nixos-raspberrypi.cachix.org"
      "https://vicinae.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
      "doom-emacs-unstraightened.cachix.org-1:O5oOlRPnmQEvVaFyuMTmthCEooHbrg54WgSLR07tmg4="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

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
