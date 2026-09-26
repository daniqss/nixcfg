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
    ./zsh.nix
    ./nushell.nix
    ./git.nix
    ./multiplexer.nix
  ];

  options.terminal = {
    enable = lib.mkEnableOption "Enable some terminal stuff";

    shell.default = lib.mkOption {
      type = lib.types.enum ["zsh" "nushell"];
      default = "zsh";
      description = ''
        Which shell config to enable by default. Each shell can still be
        enabled on its own through `terminal.shell.<name>.enable`.
      '';
    };
  };

  config = mkIf cfg.enable {
    terminal.shell = {
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
