{inputs, ...}: {
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    settings = {
      download-buffer-size = 524288000; # 500 MiB
      experimental-features = ["nix-command" "flakes"];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
  };
}
