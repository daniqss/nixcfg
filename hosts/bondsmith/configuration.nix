{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../common/nix.nix
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  users.users.daniqss = {
    initialPassword = "1234";
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  networking.networkmanager.enable = true;
}
