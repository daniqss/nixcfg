{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];

  options.server.minecraft.enable = lib.mkEnableOption "enable minecraft server profile";

  config = lib.mkIf config.server.minecraft.enable {
    # to access a mc console with `sudo tmux -S /run/minecraft/<slug>.sock attach`
    environment.systemPackages = with pkgs; [
      tmux
    ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers =
        outputs.lib.minecraft {inherit pkgs;}
        |> lib.mapAttrs (_: minecraft: minecraft.server);
    };
  };
}
