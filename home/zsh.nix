{hostname, ...}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixcfg/#${hostname}";
      update = "sudo nix flake update";

      ls = "eza --icons";
      la = "eza --icons -a";
      ll = "eza --header --icons --git -t=mod --time-style=long-iso -l";
      lla = "eza --header --icons --git -t=mod --time-style=long-iso -la";
      ts = "eza --tree --level=2";
      tsa = "eza --tree --level=2";
      tl = "eza --tree --level=2 --header --icons -t=mod --time-style=long-iso -l";
      tla = "eza --tree --level=2 --header --icons -t=mod --time-style=long-iso -la";
      treee = "eza --tree --icons";

      grep = "grep --color=auto";
      cat = "bat --paging=never --plain";
      catp = "bat --paging=never";
      icat = "kitten icat";
      cls = "clear";
    };
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
}
