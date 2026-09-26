{
  username,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg' = config.home-manager.users.${username};
  shell = {inherit (pkgs) zsh nushell;}.${cfg'.terminal.shell.default};
in {
  config = mkIf cfg'.terminal.enable {
    users.users.${username}.shell = shell;
    environment.shells = [shell];

    programs.zsh.enable = cfg'.terminal.shell.zsh.enable;
    environment.pathsToLink = mkIf cfg'.terminal.shell.zsh.enable ["/share/zsh"];
    programs.direnv.enableZshIntegration = cfg'.terminal.shell.zsh.enable;
  };
}
