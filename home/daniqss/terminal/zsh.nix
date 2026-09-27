{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.terminal.shell.zsh;
in {
  options.terminal.shell.zsh.enable = lib.mkEnableOption "Enable zsh as shell";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      inherit (cfg) enable;

      # on a foreign distro the shell comes from the distro packages
      package =
        if config.platform.isNixOS
        then pkgs.zsh
        else null;

      autocd = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

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
        tla = "${pkgs.eza}/bin/eza --tree --level=2 --header -t=mod --time-style=long-iso -la";
        treee = "${pkgs.eza}/bin/eza --tree";

        grep = "grep --color=auto";
        cat = "${pkgs.bat}/bin/bat --paging=never --plain";
        catp = "${pkgs.bat}/bin/bat --paging=never";
        cls = "clear";

        gitgraph = "git log --graph --decorate --all --pretty=format:'%C(auto)%h%d %C(#888888)(%an; %ar)%Creset %s'";
      };

      initContent = ''
        compdef eza=ls

        ${lib.optionalString true ''
          code() {
            ${lib.getExe' pkgs.vscodium "codium"} "$@" > /dev/null 2>&1
          }
        ''}

        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        bindkey "\033[1~" beginning-of-line
        bindkey "\033[4~" end-of-line
        bindkey "^H" backward-kill-word
        bindkey "\e\r" forward-char
      '';
    };

    programs.starship = {
      enable = true;

      settings = {
        format = builtins.concatStringsSep "" [
          "$all"
        ];

        character = {
          format = "$symbol ";
          success_symbol = "[❯](bold red)[❯](bold yellow)[❯](bold green)";
          error_symbol = "[❯](bold red)[❯](bold red)[❯](bold red)";
          disabled = false;
        };
      };
    };
  };
}
