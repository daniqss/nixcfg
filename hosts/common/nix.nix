{
  inputs,
  pkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [pulseaudio];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };
}
