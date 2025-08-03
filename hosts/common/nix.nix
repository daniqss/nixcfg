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
    };

    # gc = {
    #   automatic = true;
    #   options = "--delete-older-than 14d";
    # };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/${username}/nixcfg/";
  };

  programs.direnv = {
    enable = true;
    silent = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
