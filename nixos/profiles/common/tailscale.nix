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

    services.tailscale = {
      inherit (config.common.tailscale) enable;
      useRoutingFeatures = config.common.tailscale.role;
    };

    environment.systemPackages = with pkgs;
      lib.mkIf config.desktop.enable [
        tailscale-systray
      ];

    systemd.services.tailscale-cert = lib.mkIf (config.common.tailscale.role == "server" || config.common.tailscale.role == "both") {
      description = "Generate Tailscale certs";
      after = ["tailscaled.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.tailscale}/bin/tailscale cert --cert-file /var/lib/tailscale/certs/${config.networking.hostName}.tailb76493.ts.net.crt --key-file /var/lib/tailscale/certs/${config.networking.hostName}.tailb76493.ts.net.key ${config.networking.hostName}.tailb76493.ts.net";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
