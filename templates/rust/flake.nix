let
  name = "rust-template";
  description = "basic rust template";
in {
  inherit description;

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
              cargo
              cargo-expand
              rust-analyzer
              rustc
              rustfmt
              clippy
            ];

            RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
          };

        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = name;
          version = "0.1.0";

          src = self;
          cargoLock.lockFile = ./Cargo.lock;

          meta = with pkgs.lib; {
            mainProgram = name;
            inherit description;
            homepage = "https://github.com/daniqss/${name}";
            license = licenses.unlicense;
            platforms = platforms.linux;
          };
        };
      }
    );
}
