{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

  users.users = {
    daniqss = {
      initialPassword = "1234";
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    hello
    git
    curl
    nvim
  ];

  networking.networkmanager.enable = true;
}
