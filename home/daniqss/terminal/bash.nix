{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.terminal.shell.bash;
in {
  options.terminal.shell.bash.enable = lib.mkEnableOption "Enable bash as shell";

  config = lib.mkIf cfg.enable {
    programs.bash = {
      inherit (cfg) enable;

      # on a foreign distro the shell comes from the distro packages
      package =
        if config.platform.isNixOS
        then pkgs.bashInteractive
        else null;

      enableCompletion = true;
      historyControl = ["ignoreboth"];
      shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
        "autocd"
      ];

      shellAliases = let
        eza = "${pkgs.eza}/bin/eza --icons auto";
      in {
        ls = "${eza}";
        la = "${eza} -a";
        ll = "${eza} --header --git -t=mod --time-style=long-iso -l";
        lla = "${eza} --header --git -t=mod --time-style=long-iso -la";
        ts = "${eza} --tree --level=2";
        tsa = "${eza} --tree --level=2";
        tl = "${eza} --tree --level=2 --header -t=mod --time-style=long-iso -l";
        tla = "${eza} --tree --level=2 --header -t=mod --time-style=long-iso -la";
        treee = "${eza} --tree";

        grep = "grep --color=auto";
        cat = "${pkgs.bat}/bin/bat --paging=never --plain";
        catp = "${pkgs.bat}/bin/bat --paging=never";
        cls = "clear";

        gitgraph = "git log --graph --decorate --all --pretty=format:'%C(auto)%h%d %C(#888888)(%an; %ar)%Creset %s'";
      };

      initExtra = ''
        code() {
          ${lib.getExe' pkgs.vscodium "codium"} "$@" > /dev/null 2>&1
        }

        bind '"\e[1;5C": forward-word'
        bind '"\e[1;5D": backward-word'
        bind '"\e[1~": beginning-of-line'
        bind '"\e[4~": end-of-line'
        bind '"\C-h": backward-kill-word'
      '';
    };
  };
}
