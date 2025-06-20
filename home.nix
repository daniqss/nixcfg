{pkgs, ...}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "daniqss";
  home.homeDirectory = "/home/daniqss";

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

  programs.git = {
    enable = true;
    userEmail = "danielqueijo14@gmail.com";
    userName = "daniqss";
  };

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

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = [
        "${pkgs.swww}/bin/swww-daemon && ${pkgs.swww}/bin/swww img /home/daniqss/image8.png}"
      ];
      "$mainMod" = "SUPER";

      monitor = [
        "DP-1,1920x1080@143.85,0x0,1.0"
      ];

      bind =
        [
          "$mainMod, return, exec, ghostty"
          "$mainMod, TAB, exec, rofi -show drun"
          "$mainMod, W, killactive,"
          "$mainMod, Q, togglefloating,"
          "$mainMod, F, fullscreen,"
          "$mainMod, O, pseudo,"
          "$mainMod, I, togglesplit,"

          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, J, movefocus, u"
          "$mainMod, K, movefocus, d"

          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod ALT, S, movetoworkspacesilent, special:magic"
        ]
        ++ (
          # switch workspaces with super + [1-9]
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mainMod, ${toString ws}, workspace, ${toString ws}"
              ]
            )
            9)
        )
        ++ (
          # Move active window to workspace with mainMod + ALT + [1-9]
          builtins.concatLists (builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mainMod ALT, ${toString ws}, movetoworkspacesilent, ${toString ws}"
              ]
            )
            9)
        );

      # Volume control binds
      bindle = [
        ", XF86AudioRaiseVolume, exec, amixer set Master 5%+"
        ", XF86AudioLowerVolume, exec, amixer set Master 5%-"
        ", XF86AudioMute, exec, amixer set Master toggle"
        "$mainMod, XF86AudioLowerVolume, exec, playerctl previous"
        "$mainMod, XF86AudioMute, exec, playerctl play-pause"
        "$mainMod, XF86AudioRaiseVolume, exec, playerctl next"
      ];

      # Single press media control binds
      bindl = [
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", Print, exec, $screenshot"
      ];

      # Repeat binds for window resizing
      binde = [
        "$mainMod CTRL, L, resizeactive, 30 0"
        "$mainMod CTRL, H, resizeactive, -30 0"
        "$mainMod CTRL, K, resizeactive, 0 -30"
        "$mainMod CTRL, J, resizeactive, 0 30"
        "$mainMod SHIFT, H, swapwindow, l"
        "$mainMod SHIFT, L, swapwindow, r"
        "$mainMod SHIFT, J, swapwindow, d"
        "$mainMod SHIFT, K, swapwindow, u"
      ];

      # Mouse binds for moving and resizing
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      "$border" = "rgba(cba6f7ff) rgba(89b4faff) rgba(94e2d5ff) 10deg";

      general = {
        gaps_in = 6;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "$border";
        "col.inactive_border" = "rgba(00000000)";
        layout = "dwindle";
        allow_tearing = true;

        snap = {
          enabled = true;
          window_gap = 15;
          monitor_gap = 25;
          border_overlap = true;
        };
      };

      decoration = {
        rounding = 8;

        blur = {
          enabled = true;
          size = 5;
          passes = 1;
          new_optimizations = true;
          special = true;
        };
      };

      animations = {
        enabled = true;
        bezier = "overshot, 0.13, 0.99, 0.29, 1.0";

        animation = [
          "windows, 1, 4, overshot, slide"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 0"
          "workspacesIn, 0"
          "workspacesOut, 0"
          "specialWorkspace, 1, 6, overshot, slidevert"
        ];
      };

      dwindle = {
        force_split = 0;
        special_scale_factor = 0.8;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        special_scale_factor = 0.8;
      };

      misc = {
        always_follow_on_dnd = false;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
        vfr = 1;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 250;
        workspace_swipe_invert = true;
        workspace_swipe_min_speed_to_force = 15;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = false;
      };

      cursor = {
        no_hardware_cursors = 1;
      };

      device = {
        name = "elan071a:00-04f3:30fd-touchpad";
        sensitivity = 0.1;
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
