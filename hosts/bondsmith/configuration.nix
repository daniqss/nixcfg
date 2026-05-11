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
      qemu.enable = false;
      gpg.enable = false;
    };
    server = {
      enable = true;
      immich.enable = true;
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
    ];

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
    system.stateVersion = config.system.nixos.release;
  };
}
