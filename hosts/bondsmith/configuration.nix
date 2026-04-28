{
  pkgs,
  username,
  ...
}: {
  config = {
    common = {
      tailscale = {
        enable = true;
        role = "both";
      };
      syncthing.enable = false;
      qemu.enable = false;
      gpg.enable = false;
    };
    server = {
      enable = true;
      immich.enable = true;
      minecraft.enable = true;
    };
    desktop.enable = false;

    systemd.services.periodic-reboot = {
      description = "Reboot every 3 days";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/run/current-system/sw/bin/zsh -c 'sync && reboot'";
      };
    };

    systemd.timers.periodic-reboot = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* 04:00:00";
        OnUnitActiveSec = "3d";
        Persistent = true;
      };
    };

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "yes";
      };
    };

    users.users.${username} = {
      isNormalUser = true;
      description = "${username}";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
    };
    programs.zsh.enable = true;

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [mesa];
    };

    networking.networkmanager.enable = true;
    system.stateVersion = "25.05";
  };
}
