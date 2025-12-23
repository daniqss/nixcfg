{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    # ./disko.nix
    ../common/nix.nix
    # ../common/services/minecraft.nix
    # ../common/services/immich.nix
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  networking.hostId = "863585c9";
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  programs.nix-ld.enable = true;

  networking.networkmanager.enable = true;
  system.stateVersion = "25.05";

  boot.supportedFilesystems = ["zfs"];
  # networking.hostId is set somewhere else
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  boot.loader.raspberryPi.enable = true;
  hardware.raspberry-pi.config = {
    # [all] conditional filter, https://www.raspberrypi.com/documentation/computers/config_txt.html#conditional-filters
    all.options = {
      # https://www.raspberrypi.com/documentation/computers/config_txt.html#enable_uart
      # in conjunction with `console=serial0,115200` in kernel command line (`cmdline.txt`)
      # creates a serial console, accessible using GPIOs 14 and 15 (pins
      #  8 and 10 on the 40-pin header)
      enable_uart = {
        enable = true;
        value = true;
      };
      # https://www.raspberrypi.com/documentation/computers/config_txt.html#uart_2ndstage
      # enable debug logging to the UART, also automatically enables
      # UART logging in `start.elf`
      uart_2ndstage = {
        enable = true;
        value = true;
      };
    };

    # Base DTB parameters
    # https://github.com/raspberrypi/linux/blob/a1d3defcca200077e1e382fe049ca613d16efd2b/arch/arm/boot/dts/overlays/README#L132
    base-dt-params = {
      # # https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#enable-pcie
      # pciex1 = {
      #   enable = true;
      # };
      # # PCIe Gen 3.0
      # # https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#pcie-gen-3-0
      # pciex1_gen = {
      #   enable = true;
      #   value = "3";
      # };
    };
    dt-overlays = {
      # Enable DRM VC4 V3D driver
      vc4-kms-v3d = {
        enable = false;
        params = {};
      };
    };
  };
}
