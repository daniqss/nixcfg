{
  config,
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
      binfmt.enable = false;
      gpg.enable = false;
    };
    server = {
      enable = true;
      immich.enable = true;
      forgejo.enable = true;

      # tailscale ip, the other machines resolve <service>.bondsmith.tailb76493.ts.net to it
      caddy.address = "100.77.11.37";
      minecraft.enable = true;
    };
    desktop.enable = false;

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "yes";
      };
    };

    boot.kernelParams = [
      "nvme.max_host_mem_size_mb=128"
      "nvme_core.default_ps_max_latency_us=0"
      "pcie_aspm=off"
    ];

    users.users.${username} = {
      isNormalUser = true;
      description = "${username}";
      extraGroups = ["networkmanager" "wheel"];
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [mesa];
    };

    networking.networkmanager.enable = true;
    system.stateVersion = config.system.nixos.release;
  };
}
