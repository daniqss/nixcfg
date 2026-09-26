{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.terminal.shell.nushell;
in {
  options.terminal.shell.nushell.enable = mkEnableOption "enable nushell as shell";

  config = mkIf cfg.enable {
    programs.nushell = {
      inherit (cfg) enable;

      # on a foreign distro the shell comes from the distro packages
      package =
        if config.platform.isNixOS
        then pkgs.nushell
        else null;

      shellAliases = let
        eza = "${pkgs.eza}/bin/eza --icons auto";
        bat = "${pkgs.bat}/bin/bat";
      in {
        ls = "${eza}";
        la = "${eza} -a";
        ll = "${eza} --header --git -t=mod --time-style=long-iso -l";
        lla = "${eza} --header --git -t=mod --time-style=long-iso -la";
        ts = "${eza} --tree --level=2";
        tsa = "${eza} --tree --level=2 -a";
        tl = "${eza} --tree --level=2 --header -t=mod --time-style=long-iso -l";
        tla = "${eza} --tree --level=2 --header -t=mod --time-style=long-iso -la";
        treee = "${eza} --tree";

        grep = "^grep --color=auto";
        cat = "${bat} --paging=never --plain";
        catp = "${bat} --paging=never";
        cls = "clear";

        gitgraph = "^git log --graph --decorate --all --pretty=format:'%C(auto)%h%d %C(#888888)(%an; %ar)%Creset %s'";
      };

      # prompt config
      extraEnv = let
        git = lib.getExe pkgs.git;
      in ''
        $env.PROMPT_COMMAND = {||
          let dir = ($env.PWD | str replace $nu.home-dir "~")
          let branch = (
            do --ignore-errors { ^${git} rev-parse --abbrev-ref HEAD e> /dev/null }
            | default ""
            | str trim
          )
          let git = if ($branch | is-empty) { "" } else { $" (ansi purple_bold)($branch)(ansi reset)" }

          $"(ansi blue_bold)($dir)(ansi reset)($git)"
        }
        $env.PROMPT_COMMAND_RIGHT = ""

        # same three chevrons starship used to draw
        $env.PROMPT_INDICATOR = {||
          if ($env.LAST_EXIT_CODE? | default 0) == 0 {
            $"\n(ansi red_bold)❯(ansi yellow_bold)❯(ansi green_bold)❯(ansi reset) "
          } else {
            $"\n(ansi red_bold)❯❯❯(ansi reset) "
          }
        }
        $env.PROMPT_MULTILINE_INDICATOR = $"(ansi grey)::: (ansi reset)"
      '';

      # shell config
      extraConfig = ''
        $env.config.show_banner = false
        $env.config.edit_mode = "emacs"
        $env.config.completions.algorithm = "fuzzy"
        $env.config.completions.case_sensitive = false
        $env.config.filesize.unit = "metric"

        ${lib.optionalString true ''
          def --wrapped code [...args] {
            ${lib.getExe' pkgs.vscodium "codium"} ...$args out+err> /dev/null
          }
        ''}

        $env.config.keybindings ++= [
          {
            name: backward_kill_word
            modifier: control
            keycode: char_h
            mode: [emacs vi_insert]
            event: { edit: cutwordleft }
          }
          {
            name: accept_autosuggestion
            modifier: alt
            keycode: enter
            mode: [emacs vi_insert]
            event: { send: historyhintcomplete }
          }
        ]
      '';
    };
  };
}
