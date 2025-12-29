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

  config = lib.mkIf config.tailscale.enable {
    services.tailscale = {
      inherit (config.tailscale) enable;
      useRoutingFeatures = config.tailscale.role;
    };
  };
}
