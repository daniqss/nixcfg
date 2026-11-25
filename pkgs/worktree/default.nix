{
  lib,
  writers,
  git,
}: let
  # the script calls git, so put it in its PATH
  wrapperArgs = ["--prefix" "PATH" ":" (lib.makeBinPath [git])];

  # creates $out/bin/worktree running the script with nushell
  package = writers.writeNuBin "worktree" {makeWrapperArgs = wrapperArgs;} ./worktree.nu;
in
  lib.addMetaAttrs {
    description = "create a git worktree of the current repo next to it";
  }
  package
