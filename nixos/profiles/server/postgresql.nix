{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.server.postgresql;
in {
  options.server.postgresql.enable = lib.mkEnableOption "enable the server postgresql cluster";
  options.server.postgresql.backup.enable = lib.mkEnableOption "enable postgresql backup";

  config = lib.mkIf cfg.enable {
    server.postgresql.backup.enable = lib.mkDefault true;

    services.postgresql = {
      enable = true;

      # fixed postgresql version to avoid cluster changes
      package = pkgs.postgresql_17;
    };

    services.postgresqlBackup = lib.mkIf cfg.backup.enable {
      enable = true;
      startAt = "*-*-* 03:00:00";
      location = "/var/backup/postgresql";
      compression = "zstd";
    };
  };
}
