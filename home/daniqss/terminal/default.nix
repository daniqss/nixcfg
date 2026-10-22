{
  outputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  cfg = config.terminal;
in {
  imports = [
    ./zsh.nix
    ./nushell.nix
    ./git.nix
    ./ssh.nix
    ./multiplexer.nix
  ];

  options.terminal = {
    enable = lib.mkEnableOption "Enable some terminal stuff";

    shell = outputs.lib.mkProgramGroupOptions {
      description = ''
        Which shell to use. The package will be installed in NixOS config from this selection
      '';
      packages = with pkgs; [zsh nushell];
      default = pkgs.zsh;
    };
  };

  config = mkIf cfg.enable {
    terminal.shell.enable = mkDefault true;

    home.packages = with pkgs; [
      bat
      eza
      killall
      fastfetch
      bottom
      htop
      cava

      micro

      zip
      unzip

      timg
    ];
  };
}
