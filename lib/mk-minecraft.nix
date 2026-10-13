{pkgs}: let
  inherit (pkgs) lib;
in
  {
    name,
    slug ? lib.toLower (lib.replaceStrings [" "] ["-"] name),
    version,
    loaderVersion,
    port ? 25565,
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

        serverProperties = {
          motd = name;
          server-port = port;
        };

        # the nixos module runs this wrapper as the unit's ExecStart
        binEntry.name = "${slug}-server";

        service = {
          enable = true;
          autoStart = true;
        };

        files = lib.optionalAttrs (icon != null) {
          "server-icon.png".source = icon;
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
