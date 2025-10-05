{
  description = "basic rust template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    systems = ["x86_64-linux" "aarch64-linux"];

    forAllSystems = f:
      builtins.listToAttrs (map (system: {
          name = system;
          value = f system;
        })
        systems);
  in {
    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          cargo
          cargo-expand
          rust-analyzer
          rustc
          rustfmt
          clippy
        ];

        RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
      };
    });
  };
}
