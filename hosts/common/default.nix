{
  username,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./gaming.nix
    ./minecraft.nix
    ./network.nix
    ./nix.nix
  ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
  environment.pathsToLink = ["/share/zsh"];
  environment.systemPackages = with pkgs; [pulseaudio];

  # for gtk
  programs.dconf.enable = true;

  programs.zsh.enable = true;

  time.timeZone = "Europe/Madrid";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # programs.uwsm = {
  #   enable = true;
  #   waylandCompositors.hyprland = {
  #     prettyName = "Hyprland";
  #     comment = "Hyprland compositor managed by UWSM";
  #     binPath = "/home/${username}/.nix-profile/bin/Hyprland";
  #   };
  # };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    config.hyprland = {
      default = ["hyprland"];
      "org.freedesktop.impl.portal.FileChooser" = ["gnome"];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-hyprland
    ];
  };

  services.greetd = {
    enable = true;
    settings = {
      terminal.vt = 1;
      default_session = let
        tuigreet = lib.getExe pkgs.tuigreet;
        options = let
          options = [
            "--asterisks"
            "--time"
            "--remember"
            "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
          ];
        in
          lib.concatStringsSep " " options;
      in {
        command = "${tuigreet} ${options}";
        user = "greeter";
      };
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.hyprland.enableGnomeKeyring = true;
}
