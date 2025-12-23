{
  pkgs,
  hostname,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
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

  networking.hostId = hostname;
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
}
