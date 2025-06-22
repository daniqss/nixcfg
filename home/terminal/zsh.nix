{
  hostname,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixcfg/#${hostname}";
      update = "sudo nix flake update";

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
