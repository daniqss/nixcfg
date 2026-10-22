# servers whose caddy exposes services as <service>.<hostname>.tailb76493.ts.net
#
# tailscale doesn't resolve nor issue certs for subdomains of a machine yet,
# so the other machines get them in /etc/hosts and trust the caddy internal ca
# waiting for #1196 and #7081 to be enabled
# https://github.com/tailscale/tailscale/issues/1196
# https://github.com/tailscale/tailscale/issues/7081
{
  inputs,
  outputs,
}: let
  inherit (inputs.nixpkgs) lib;
in
  outputs.nixosConfigurations
  |> lib.filterAttrs (_: host: let
    inherit (host.config) server;
  in
    server.enable && server.caddy.enable && server.caddy.address != null)
  |> lib.mapAttrsToList (hostname: host: let
    caddy = host.config.server.caddy;

    # TODO: use sops for full automation
    # for now copied from /var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt
    ca = ../hosts/${hostname}/caddy-root.crt;
  in {
    inherit hostname;
    inherit (caddy) address;
    domains =
      caddy.proxies
      |> lib.attrNames
      |> map (service: "${service}.${caddy.domain}");
    ca = lib.optional (builtins.pathExists ca) ca;
  })
