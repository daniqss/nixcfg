{
  inputs,
  outputs,
  username,
  flakeDir,
  ...
}: {
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    settings =
      outputs.lib.nixSettings
      // {
        trusted-users = ["root" "@wheel" username];
      };
  };

  programs.nix-ld.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 25d --keep 10";
    flake = flakeDir;
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
}
