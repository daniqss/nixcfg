{
  config,
  lib,
  ...
}: let
  cfg = config.server.dns;
in {
  options.server.dns = {
    enable = lib.mkEnableOption "enable Blocky DNS server";

    address = lib.mkOption {
      type = lib.types.str;
      default = config.server.caddy.address;
      defaultText = lib.literalExpression "config.server.caddy.address";
      description = "tailscale ip blocky listens on";
    };

    unrestricted = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "client tailscale ips that don't get social media blocked";
    };
  };

  config = lib.mkIf cfg.enable {
    services.blocky = {
      enable = true;
      settings = {
        ports.dns = "${cfg.address}:53";

        upstreams.groups.default = [
          "https://1.1.1.1/dns-query"
          "https://9.9.9.9/dns-query"
        ];

        blocking = {
          # *.domain matches the domain and all its subdomains
          denylists.social = [
            ''
              # instagram and threads
              *.instagram.com
              *.cdninstagram.com
              *.instagr.am
              *.ig.me
              *.threads.net
              *.threads.com

              # twitter
              *.x.com
              *.twitter.com
              *.twimg.com
              *.twttr.com
              *.t.co

              # reddit
              *.reddit.com
              *.redd.it
              *.redditmedia.com
              *.redditstatic.com
              *.reddituploads.com
            ''
          ];

          # blocky falls back to the default group for clients without groups,
          # so the unrestricted ones need a group that blocks nothing
          denylists.unrestricted = [
            ''
              # nothing blocked
            ''
          ];

          clientGroupsBlock =
            {default = ["social"];}
            // lib.genAttrs cfg.unrestricted (_: ["unrestricted"]);
        };
      };
    };

    # tailscale may not have assigned the ip yet when blocky starts
    boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = 1;
    systemd.services.blocky.after = ["tailscaled.service"];

    networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
      allowedTCPPorts = [53];
      allowedUDPPorts = [53];
    };
  };
}
