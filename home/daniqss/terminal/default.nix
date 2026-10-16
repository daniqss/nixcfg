{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  cfg = config.terminal;
in {
  imports = [
    ./bash.nix
    ./zsh.nix
    ./nushell.nix
    ./starship.nix
    ./git.nix
    ./multiplexer.nix
  ];

  options.terminal = {
    enable = lib.mkEnableOption "Enable some terminal stuff";

    shell.default = lib.mkOption {
      type = lib.types.enum ["bash" "zsh" "nushell"];
      default = "bash";
      description = ''
        Which shell to use. The package will be installed in NixOS config from this selection
      '';
    };
  };

  config = mkIf cfg.enable {
    terminal.shell = {
      bash.enable = mkDefault (cfg.shell.default == "bash");
      zsh.enable = mkDefault (cfg.shell.default == "zsh");
      nushell.enable = mkDefault (cfg.shell.default == "nushell");
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

      zip
      unzip

      timg
    ];
  };
}
