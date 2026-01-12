{
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
  };
}
