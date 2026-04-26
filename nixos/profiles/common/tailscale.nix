{
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

    # to allow caddy to read the certs
    users.groups.tailscale-certs = {};

    systemd.tmpfiles.settings."10-tailscale-certs" = {
      "/var/lib/tailscale"."z" = {
        mode = "0751";
        user = "root";
        group = "root";
      };
      "/var/lib/tailscale/certs"."d" = {
        mode = "0750";
        user = "root";
        group = "tailscale-certs";
      };
    };

    services.tailscale = {
      enable = true;
      useRoutingFeatures = config.common.tailscale.role;
    };

    environment.systemPackages = with pkgs;
      lib.mkIf config.desktop.enable [
        tailscale-systray
      ];

    systemd.services.tailscale-cert = let
      domain = "${config.networking.hostName}.tailb76493.ts.net";
      certPath = "/var/lib/tailscale/certs/${domain}.crt";
      keyPath = "/var/lib/tailscale/certs/${domain}.key";
    in
      lib.mkIf (config.common.tailscale.role == "server" || config.common.tailscale.role == "both") {
        description = "Generate Tailscale certs";
        after = ["tailscaled.service"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = [
            "${pkgs.coreutils}/bin/mkdir -p /var/lib/tailscale/certs"
            "${pkgs.tailscale}/bin/tailscale cert --cert-file ${certPath} --key-file ${keyPath} ${domain}"
            "${pkgs.coreutils}/bin/chgrp tailscale-certs ${certPath} ${keyPath}"
            "${pkgs.coreutils}/bin/chmod 640 ${certPath} ${keyPath}"
          ];
        };
        wantedBy = ["multi-user.target"];
      };
  };
}
