_: {
  projectRootFile = "flake.nix";

  programs = {
    alejandra.enable = true;
    deadnix.enable = true;
    statix.enable = true;

    stylua.enable = true;

    shfmt.enable = true;
    shellcheck.enable = true;

    taplo.enable = true;
    yamlfmt.enable = true;
    just.enable = true;
  };

  settings.formatter = {
    shfmt.options = ["-i" "2" "-s" "-bn"];
    shellcheck.excludes = [".envrc" "**/.envrc"];
  };

  settings.global.excludes = [
    "LICENSE"
    ".gitignore"
    "secrets/*"
  ];
}
