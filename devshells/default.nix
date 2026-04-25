{pkgs, ...}: {
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      alejandra
      statix
      deadnix
    ];
  };

  eduroam = import ./eduroam.nix {inherit pkgs;};
}
