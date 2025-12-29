{
  inputs,
  username,
  lib,
  config,
  pkgs,
  ...
}: let
  # worldToServer = pkgs.writeShellScriptBin "world-to-server" ''
  #   #!/usr/bin/env bash
  #   set -euo pipefail
  #   SERVER_DIR="/srv/minecraft/mc-gf"
  #   WORLD_DIR="$SERVER_DIR/world"
  #   if [[ $# -ne 1 ]]; then
  #     echo "Usage: $0 <path-to-world>"
  #     exit 1
  #   fi
  #   NEW_WORLD="$(realpath "$1")"
  #   if [[ ! -d "$NEW_WORLD" ]]; then
  #     echo "Non valid Minecraft world directory: $NEW_WORLD"
  #     exit 1
  #   fi
  #   if [[ ! -f "$NEW_WORLD/level.dat" ]]; then
  #     echo "Non valid Minecraft world directory, no level.dat: $NEW_WORLD"
  #     exit 1
  #   fi
  #   if [[ -d "$WORLD_DIR" ]]; then
  #     BACKUP="$SERVER_DIR/world.$(date +%Y%m%d%H%M%S).bak"
  #     sudo mv "$WORLD_DIR" "$BACKUP"
  #   fi
  #   sudo cp -r "$NEW_WORLD" "$WORLD_DIR"
  #   sudo chown -R "$MC_USER:$MC_GROUP" "$WORLD_DIR"
  #   sudo find "$WORLD_DIR" -type d -exec chmod 770 {} \;
  #   sudo find "$WORLD_DIR" -type f -exec chmod 660 {} \;
  #   if [[ -f "$WORLD_DIR/session.lock" ]]; then
  #     sudo rm -f "$WORLD_DIR/session.lock"
  #   fi
  # '';
in {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];

  options.server.minecraft.enable = lib.mkEnableOption "enable minecraft server profile";

  config = lib.mkIf config.server.minecraft.enable {
    # to access mc console with with `sudo tmux -S /run/minecraft/mc-gf.sock`
    environment.systemPackages = with pkgs; [
      tmux
    ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers.mc-gf = {
        enable = true;

        serverProperties = {
          motd = "mc con pauli";
          allow-cheats = true;
        };

        package = pkgs.fabricServers.fabric-1_21_10.override {
          loaderVersion = "0.18.1";
        };

        symlinks = {
          mods = pkgs.linkFarmFromDrvs "mods" (
            builtins.attrValues {
              Fabric-API = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/dQ3p80zK/fabric-api-0.138.3%2B1.21.10.jar";
                sha512 = "sha512-3HOjZTwplHbR9wy2ksTjWsP2lLOwhz49C3KelS6ZK4eNGo4LHRBJpEKg1IPTBoBzGU8Vr1LqmThURhbiBDPMOA==";
              };
              Carpet = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/TQTTVgYE/versions/oiUqSOMA/fabric-carpet-1.21.10-1.4.188%2Bv251016.jar";
                sha512 = "sha512-36uTeE/KpzsghUhXBjAl02ovfCc5fMZLFB/iyFAkmTqHk2AWrII8LJRfJzFLmTiqV+BrVWdqHDScEhtEXs/iEw==";
              };
            }
          );

          # "server-icon.png" = "/home/${username}/minecraft/mc-gf/server-icon.png";
          # world = "/home/${username}/minecraft/mc-gf/world";
        };
      };
    };
  };
}
