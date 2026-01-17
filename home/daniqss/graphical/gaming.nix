{
  inputs,
  hostname,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  options.graphical.gaming.enable = lib.mkEnableOption "enable gaming packages session";

  config = lib.mkIf (config.graphical.enable
    && config.graphical.gaming.enable) {
    home.packages = with pkgs; [
      # minecraft launcher
      prismlauncher

      # hollow knight mod manager
      scarab
    ];

    # roblox
    services.flatpak.packages = lib.mkIf (hostname == "stoneward") [
      {
        appId = "org.vinegarhq.Sober";
        origin = "flathub";
      }
    ];
  };
}
