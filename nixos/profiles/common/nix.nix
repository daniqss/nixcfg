{
  inputs,
  username,
  flakeDir,
  ...
}: let
  # caches and extra features come straight from the flake's own nixConfig, so
  # the nix cli and the built system cannot drift apart
  inherit (import ../../../flake.nix) nixConfig;
in {
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    settings =
      {
        extra-substituters = [
          "https://nvf.cachix.org"
          "https://doom-emacs-unstraightened.cachix.org"
          "https://nixos-raspberrypi.cachix.org"
          "https://vicinae.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
          "doom-emacs-unstraightened.cachix.org-1:O5oOlRPnmQEvVaFyuMTmthCEooHbrg54WgSLR07tmg4="
          "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
          "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        ];

        download-buffer-size = 524288000;
        trusted-users = ["root" "@wheel" username];
      }
      // nixConfig;
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
