{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  instances = outputs.lib.minecraft {inherit pkgs;};
in {
  imports = [inputs.nixcraft.nixosModules.default];

  options.server.minecraft.enable = lib.mkEnableOption "enable minecraft server profile";

  config = lib.mkIf config.server.minecraft.enable {
    # instance dir is /var/lib/nixcraft/server/instances/<slug>, logs with
    # `journalctl -u nixcraft-server-<slug>`
    nixcraft = {
      enable = true;

      server.instances = lib.mapAttrs (_: minecraft: minecraft.server) instances;
    };

    # nixcraft brings no openFirewall of its own
    networking.firewall.allowedTCPPorts =
      instances
      |> lib.attrValues
      |> map (minecraft: minecraft.port);
  };
}
