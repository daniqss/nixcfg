{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    nixd
  ];

  # programs.direnv = {
  #   enable = true;
  #   nix-direnv.enable = true;
  #   enableZshIntegration = true;
  # };
}
