{
  outputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options.common.tailscale = {
    enable = lib.mkEnableOption "enable Tailscale VPN client";

    role = lib.mkOption {
      type = lib.types.enum ["server" "client" "both" "none"];
      default = "none";
      description = "tailscale role to use ";
    };
  };

  config = lib.mkIf config.common.tailscale.enable {
    services.resolved.enable = true;

    # homelab services, see lib/homelab.nix
    networking.hosts =
      outputs.lib.homelab
      |> map (server: {${server.address} = server.domains;})
      |> lib.zipAttrsWith (_: lib.concatLists);
    security.pki.certificateFiles =
      outputs.lib.homelab
      |> lib.concatMap (server: server.ca);

    services.tailscale = {
      enable = true;
      useRoutingFeatures = config.common.tailscale.role;
      permitCertUid = "caddy";
    };

    environment.systemPackages = lib.mkIf config.desktop.enable [
      pkgs.tailscale-systray
    ];
  };
}
