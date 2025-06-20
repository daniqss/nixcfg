{pkgs, ...}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "daniqss";
  home.homeDirectory = "/home/daniqss";

  imports = [
    ./git.nix
    ./hyprland.nix
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the "hello" command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don"t forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command "my-hello" to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ""
    #   echo "Hello, ${config.home.username}!"
    # "")
  ];

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/nixcfg/#stoneward";

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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through "home.file".
  home.file = {
    # # Building this configuration will create a copy of "dotfiles/screenrc" in
    # # the Nix store. Activating the configuration will then make "~/.screenrc" a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ""
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # "";
  };

  # Home Manager can also manage your environment variables through
  # "home.sessionVariables". These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don"t want to manage your shell
  # through Home Manager then you have to manually source "hm-session-vars.sh"
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/daniqss/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      jnoortheen.nix-ide
    ];
    profiles.default.userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
  };

  # programs.ssh = {
  #   enable = true;
  #
  #   matchBlocks = {
  #     "github.com" = {
  #       hostname = "github.com";
  #       user = "git";
  #       identityFile = "~/.ssh/github_ed25519";
  #       identitiesOnly = true;
  #     };
  #   };
  # };
  #
  # home.file.".ssh/github".source = "/home/daniqss/.ssh/github_ed25519";
  # home.file.".ssh/github.pub".source = "/home/daniqss/.ssh/github_ed25519.pub";
}
