{
  username,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.home-manager.users.${username}.terminal;

  shell = {inherit (pkgs) zsh nushell;}.${cfg.shell.default};
in {
  config = lib.mkIf cfg.enable {
    users.users.${username}.shell = shell;
    environment.shells = [shell];

    # zsh needs its nixos module for the system wide completions
    programs.zsh.enable = cfg.shell.zsh.enable;
    environment.pathsToLink = lib.mkIf cfg.shell.zsh.enable ["/share/zsh"];
  };
}
