{
  username,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./gaming.nix
    ./minecraft.nix
    ./network.nix
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

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.pathsToLink = ["/share/zsh"];
  environment.systemPackages = with pkgs; [pulseaudio];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

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

  programs.uwsm = {
    enable = true;

    waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/home/${username}/.nix-profile/bin/Hyprland";
    };
  };
}
