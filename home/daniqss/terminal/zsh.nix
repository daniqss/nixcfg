{
  pkgs,
  lib,
  config,
  ...
}: let
in {
  config = lib.mkIf config.terminal.enable {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      shellAliases = {
        ls = "${pkgs.eza}/bin/eza --icons";
        la = "${pkgs.eza}/bin/eza --icons -a";
        ll = "${pkgs.eza}/bin/eza --header --icons --git -t=mod --time-style=long-iso -l";
        lla = "${pkgs.eza}/bin/eza --header --icons --git -t=mod --time-style=long-iso -la";
        ts = "${pkgs.eza}/bin/eza --tree --level=2";
        tsa = "${pkgs.eza}/bin/eza --tree --level=2";
        tl = "${pkgs.eza}/bin/eza --tree --level=2 --header --icons -t=mod --time-style=long-iso -l";
        tla = "${pkgs.eza}/bin/eza --tree --level=2 --header --icons -t=mod --time-style=long-iso -la";
        treee = "${pkgs.eza}/bin/eza --tree --icons";

        grep = "grep --color=auto";
        cat = "${pkgs.bat}/bin/bat --paging=never --plain";
        catp = "${pkgs.bat}/bin/bat --paging=never";
        icat = "kitten icat";
        cls = "clear";

        gitgraph = "git log --graph --decorate --all --pretty=format:'%C(auto)%h%d %C(#888888)(%an; %ar)%Creset %s'";
      };

      initContent = ''
        compdef eza=ls

        ${lib.optionalString config.graphical.enable ''
          code() {
            ${pkgs.vscode}/bin/code "$@" > /dev/null 2>&1
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
