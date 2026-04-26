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
      enable = true;
      useRoutingFeatures = config.common.tailscale.role;
      permitCertUid = "caddy";
    };

    environment.systemPackages = lib.mkIf config.desktop.enable [
      pkgs.tailscale-systray
    ];
  };
}
