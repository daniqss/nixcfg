{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
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

          # to add world and server icon:
          # ```sh
          # mv /srv/minecraft/mc-gf/world /srv/minecraft/mc-gf/world.bak
          # cp -r /home/daniqss/minecraft/mc-gf/world /srv/minecraft/mc-gf/
          # cp /home/daniqss/minecraft/mc-gf/server-icon.png /srv/minecraft/mc-gf/
          # chown -R minecraft:minecraft /srv/minecraft/mc-gf/world
          # chown -R minecraft:minecraft /srv/minecraft/mc-gf/server-icon.png
          # rm /srv/minecraft/mc-gf/world/session.lock
          # find /srv/minecraft/mc-gf/world -type d -exec chmod 770 {} \;
          # find /srv/minecraft/mc-gf/world -type f -exec chmod 660 {} \;
          # ```
        };
      };
    };
  };
}
