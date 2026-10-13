{pkgs}: let
  inherit (pkgs) lib;
in
  {
    name,
    slug ? lib.toLower (lib.replaceStrings [" "] ["-"] name),
    version,
    loaderVersion,
    port ? 25565,
    whitelist ? null,
    icon ? null,
    mods ? {},
    clientMods ? {},
    server ? {},
    client ? {},
  }: {
    inherit name slug version loaderVersion port mods clientMods;
    server =
      lib.recursiveUpdate {
        enable = true;

        inherit version;

        agreeToEula = true;

        fabricLoader = {
          enable = true;
          version = loaderVersion;
        };

        # nixcraft names each jar after its store path,
        # the attribute names are only ours to read
        mods = lib.attrValues mods;

        serverProperties =
          {
            motd = name;
            server-port = port;
          }
          // lib.optionalAttrs (whitelist != null) {
            white-list = true;
            enforce-whitelist = true;
          };

        # the nixos module runs this wrapper as the unit's ExecStart
        binEntry.name = "${slug}-server";

        service = {
          enable = true;
          autoStart = true;
        };

        files =
          lib.optionalAttrs (icon != null) {
            "server-icon.png".source = icon;
          }
          // lib.optionalAttrs (whitelist != null) {
            # copied, not symlinked, so `/whitelist add` still works until the next restart
            "whitelist.json" = {
              method = "copy";
              text = builtins.toJSON (lib.mapAttrsToList (name: uuid: {inherit name uuid;}) whitelist);
            };
          };
      }
      server;

    client =
      lib.recursiveUpdate {
        enable = true;

        inherit version;

        fabricLoader = {
          enable = true;
          version = loaderVersion;
        };

        mods = lib.attrValues (mods // clientMods);

        binEntry = {
          enable = true;
          name = slug;
        };

        desktopEntry = {
          enable = true;
          inherit name;

          extraConfig =
            {
              terminal = false;
            }
            // lib.optionalAttrs (icon != null) {
              icon = "${icon}";
            };
        };
      }
      client;
  }
