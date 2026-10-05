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

  pythonShell = pkgs.mkShell {
    buildInputs = with pkgs; [
      python314
      uv
      ruff
      ty
    ];
  };

  eduroam = import ./eduroam.nix {inherit pkgs;};
}
