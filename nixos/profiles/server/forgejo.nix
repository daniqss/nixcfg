{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.forgejo;
  domain = "git.${config.server.caddy.domain}";
in {
  options.server.forgejo.enable = lib.mkEnableOption "enable Forgejo git server";

  config = lib.mkIf config.server.forgejo.enable {
    server.postgresql.enable = lib.mkDefault true;

    server.caddy.proxies.git.upstream = "unix/${cfg.settings.server.HTTP_ADDR}";

    # after the first switch, once caddy is set up (see caddy.nix), create the admin with
    # forgejo-admin user create --admin --username <user> --email <email> --random-password
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "forgejo-admin" ''
        exec sudo -u ${cfg.user} ${lib.getExe cfg.package} \
          --work-path ${cfg.stateDir} --config ${cfg.customDir}/conf/app.ini admin "$@"
      '')
    ];

    # git over the system openssh, so clone urls are git@${domain}:<owner>/<repo>
    # the forgejo module only creates its user when it's named forgejo
    users.users.git = {
      home = cfg.stateDir;
      useDefaultShell = true;
      group = "git";
      isSystemUser = true;
    };
    users.groups.git = {};

    services.forgejo = {
      enable = true;
      user = "git";
      group = "git";

      database = {
        type = "postgres";
        # nixos creates the database only if the db user, db name and forgejo user match
        user = "git";
        name = "git";
      };

      lfs.enable = true;

      settings = {
        server = {
          # caddy talks to the socket, so forgejo doesn't listen on any port
          PROTOCOL = "http+unix";
          DOMAIN = domain;
          ROOT_URL = "https://${domain}/";
          SSH_DOMAIN = domain;
        };

        session.COOKIE_SECURE = true;
        service.DISABLE_REGISTRATION = true;

        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
      };
    };
  };
}
