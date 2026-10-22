{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dev.agents.claude;
in {
  options.dev.agents.claude.enable = mkEnableOption "enable claude code";

  config = mkIf cfg.enable {
    programs.claude-code = {
      enable = true;

      # global ~/.claude/CLAUDE.md, loaded before each project's CLAUDE.md or AGENTS.md
      context = ''
        - The user's interactive shell is ${lib.getName config.terminal.shell.default}.
      '';
    };
  };
}
