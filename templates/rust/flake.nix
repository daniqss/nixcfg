{
  description = "basic rust template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    fenix.url = "github:nix-community/fenix";
  };

  outputs = {
    nixpkgs,
    fenix,
    ...
  }: let
    eachSystem = f:
      nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"]
      (system:
        f system (import nixpkgs {
          inherit system;
          overlays = [fenix.overlays.default];
        }));
  in {
    devShells = eachSystem (system: pkgs: {
      default = pkgs.mkShell {
        buildInputs = [
          pkgs.cargo
          pkgs.cargo-expand
          pkgs.rust-analyzer
          pkgs.rustc
          pkgs.clippy
          fenix.packages.${system}.latest.rustfmt
        ];

        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
      };
    });
  };
}
