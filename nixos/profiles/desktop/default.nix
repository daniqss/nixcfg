{
  username,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./pinnacle.nix
    ./gaming.nix
  ];

  options.desktop.enable = lib.mkEnableOption "enable default desktop profile";

  config = lib.mkIf config.desktop.enable {
    desktop.gaming.enable = lib.mkDefault true;

    services.gvfs.enable = true;
    services.upower.enable = true;
    programs.dconf.enable = true;
    security.polkit.enable = true;

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
    };

    users.users.${username} = {
      isNormalUser = true;
      description = "${username}";
      extraGroups = ["networkmanager" "wheel" "kvm" "adbusers"];
      shell = pkgs.zsh;
    };
    environment.pathsToLink = ["/share/zsh"];
    environment.systemPackages = with pkgs; [
      pulseaudio
      distrobox
    ];
    services.flatpak.enable = true;

    programs.adb.enable = true;
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

    security.pam = {
      enableFscrypt = true;

      services = {
        greetd.enableGnomeKeyring = true;
        hyprland.enableGnomeKeyring = true;
      };
    };
  };
}
