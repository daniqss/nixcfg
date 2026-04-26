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

  eduroam = import ./eduroam.nix {inherit pkgs;};
}
