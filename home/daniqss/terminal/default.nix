{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./zsh.nix
    ./git.nix
  ];
  
  options.terminal.enable = lib.mkEnableOption "Enable some terminal";

  config = lib.mkIf config.terminal.enable {
    home.packages = with pkgs; [
      bat
      eza
      killall
      fastfetch
      bottom
      htop
      cava

      micro
      neovim
    ];
  };
}
