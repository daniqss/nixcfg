_: {
  extra-experimental-features = ["nix-command" "flakes" "pipe-operators"];

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
}
