{
  description = "basic opengl in c template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = [
              gnumake
              gcc
              freeglut
              libGLU
            ];
          };
      }
    );
}
