{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./zsh.nix
    ./git.nix
    ./terminfo.nix
  ];

  options.terminal.enable = lib.mkEnableOption "Enable some terminal";

  config = lib.mkIf config.terminal.enable {
    terminal.terminfo.enable = lib.mkDefault false;

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
