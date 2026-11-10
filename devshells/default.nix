{pkgs, ...}: {
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      just

      alejandra
      statix
      deadnix

      stylua

      shfmt
      shellcheck

      taplo
      yamlfmt
      just-formatter
    ];
  };

  python = pkgs.mkShell {
    buildInputs = with pkgs; [
      python314
      uv
      ruff
      ty
    ];
  };

  c = pkgs.mkShell {
    buildInputs = with pkgs; [
      gnumake
      clang-tools
    ];
  };

  eduroam = import ./eduroam.nix {inherit pkgs;};
}
