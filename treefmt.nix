{pkgs, ...}: {
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

    stylua.excludes = ["**/matugen/templates/*.lua"];

    qmlformat = {
      command = "${pkgs.kdePackages.qtdeclarative}/bin/qmlformat";
      options = ["-i"];
      includes = ["*.qml"];
    };

    # config in nufmt.nuon
    nufmt = {
      command = "${pkgs.nufmt}/bin/nufmt";
      options = ["--config" "nufmt.nuon"];
      includes = ["*.nu"];
      priority = 1;
    };

    # nufmt happily "formats" broken code, so check that scripts still parse after it
    nu-check = {
      command = pkgs.writers.writeNuBin "nu-check" ''
        def main [...files: path] {
          let broken = $files | where {|file| not (nu-check ($file | path expand)) }
          if ($broken | is-not-empty) {
            print --stderr $"nu parse errors in: ($broken | str join ', ')"
            exit 1
          }
        }
      '';
      includes = ["*.nu"];
      priority = 2;
    };
  };

  settings.global.excludes = [
    "LICENSE"
    ".gitignore"
    "secrets/*"
  ];
}
