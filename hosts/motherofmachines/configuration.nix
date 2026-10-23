{
  username,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../nixos/profiles/common/nix.nix
    ../../nixos/profiles/common/shell.nix
  ];

  config = {
    boot.loader.systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 10;
      consoleMode = "auto";
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.plymouth.enable = true;
    boot.kernelParams = ["quiet" "splash"];

    hardware.graphics.enable = true;
    hardware.bluetooth.enable = true;

    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Madrid";
    i18n.defaultLocale = "es_ES.UTF-8";
    console.useXkbConfig = true;
    services.xserver.xkb.layout = "es";

    services.displayManager.plasma-login-manager.enable = true;
    services.desktopManager.plasma6.enable = true;

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    services.printing.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.flatpak.enable = true;
    systemd.services.flatpak-repo = {
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target"];
      path = [pkgs.flatpak];
      script = "flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo";
    };

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id.indexOf("org.freedesktop.Flatpak.") == 0 &&
            action.id != "org.freedesktop.Flatpak.override-parental-controls" &&
            subject.local && subject.active && subject.isInGroup("users")) {
          return polkit.Result.YES;
        }
      });
    '';

    users.users = {
      ${username} = {
        isNormalUser = true;
        extraGroups = ["networkmanager" "wheel"];
      };
      romina = {
        isNormalUser = true;
        description = "Romina";
        extraGroups = ["networkmanager" "lpadmin"];
      };
    };

    home-manager.useUserPackages = true;

    nix.optimise.automatic = true;

    system.stateVersion = config.system.nixos.release;
  };
}
