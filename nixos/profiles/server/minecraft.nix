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

    # <slug>.<domain> needs the caddy root ca on the other hosts, see caddy.nix
    server.caddy.proxies =
      instances
      |> lib.mapAttrs' (_: minecraft:
        lib.nameValuePair minecraft.slug {
          upstream = "http://127.0.0.1:${toString minecraft.port}";
        });

    # nixcraft brings no openFirewall of its own
    networking.firewall.allowedTCPPorts =
      instances
      |> lib.attrValues
      |> map (minecraft: minecraft.port);
  };
}
