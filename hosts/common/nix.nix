{
  inputs,
  username,
  ...
}: {
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    settings = {
      download-buffer-size = 524288000; # 500 MiB
      experimental-features = ["nix-command" "flakes"];

      substituters = [
        "https://nixos-raspberrypi.cachix.org"
        "https://cache.nixos-cuda.org"
      ];
      trusted-substituters = ["https://nixos-raspberrypi.cachix.org"];
      trusted-public-keys = [
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 25d --keep 10";
    flake = "/home/${username}/nixcfg/";
  };

  programs.direnv = {
    enable = true;
    silent = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
