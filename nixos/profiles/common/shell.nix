{
  username,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg' = config.home-manager.users.${username};
  shells = {
    inherit (pkgs) zsh nushell;
    bash = pkgs.bashInteractive;
  };
  shell = shells.${cfg'.terminal.shell.default};
in {
  config = mkIf cfg'.terminal.enable {
    users.users.${username}.shell = shell;
    environment.shells = [shell];

    programs.zsh.enable = cfg'.terminal.shell.zsh.enable;
    # home-manager runs compinit itself, avoid doing it twice
    programs.zsh.enableGlobalCompInit = false;
    environment.pathsToLink = mkIf cfg'.terminal.shell.zsh.enable ["/share/zsh"];
    programs.direnv.enableZshIntegration = cfg'.terminal.shell.zsh.enable;
  };
}
