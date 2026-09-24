{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf;
in {
  imports = [
    ./zsh.nix
    ./git.nix
    ./multiplexer.nix
  ];

  options.terminal.enable = lib.mkEnableOption "Enable some terminal stuff";

  config = mkIf config.terminal.enable {
    terminal.shell.zsh = {
      enable = mkDefault true;
      package = mkDefault pkgs.zsh;
    };

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

      zip
      unzip

      timg
    ];
  };
}
