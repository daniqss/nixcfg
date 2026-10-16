{
  config,
  lib,
  ...
}: {
  options.terminal.multiplexer.zellij.enable = lib.mkEnableOption "zellij with SSH auto-attach";

  config = lib.mkIf config.terminal.multiplexer.zellij.enable {
    programs.zellij = {
      enable = true;

      # ctrl g is used to launch editor in some programs
      extraConfig = ''
        keybinds {
            locked {
                unbind "Ctrl g"
                bind "Ctrl Alt g" { SwitchToMode "Normal"; }
            }
            shared_except "locked" {
                unbind "Ctrl g"
                bind "Ctrl Alt g" { SwitchToMode "Locked"; }
            }
        }
      '';
    };
  };
}
