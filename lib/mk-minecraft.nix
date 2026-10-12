{pkgs}: let
  inherit (pkgs) lib;
in
  {
    name,
    slug ? lib.toLower (lib.replaceStrings [" "] ["-"] name),
    version,
    dataVersion,
    loaderVersion,
    port ? 25565,
    icon ? null,
    mods ? {},
    clientMods ? {},
    assetsHash ? lib.fakeHash,
    server ? {},
    client ? {},
  }: let
    escapedVersion = lib.replaceStrings ["."] ["_"] version;

    serverJre = pkgs."jdk${lib.versions.major pkgs.vanillaServers."vanilla-${escapedVersion}".passthru.java.version}_headless";
  in {
    inherit name slug version dataVersion loaderVersion port mods clientMods;

    server =
      lib.recursiveUpdate {
        enable = true;

        serverProperties = {
          motd = name;
          server-port = port;
        };

        package = pkgs.fabricServers."fabric-${escapedVersion}".override {
          inherit loaderVersion;
          jre_headless = serverJre;
        };

        symlinks =
          {
            mods =
              mods
              |> builtins.attrValues
              |> pkgs.linkFarmFromDrvs "mods";
          }
          // lib.optionalAttrs (icon != null) {
            "server-icon.png" = icon;
          };
      }
      server;

    client =
      lib.recursiveUpdate {
        enable = true;

        inherit version;

        # avoid a derivation per asset
        fastAssetDownload = {
          enable = true;
          hash = assetsHash;
        };

        fabricLoader = {
          enable = true;
          version = loaderVersion;
        };

        mods = mods // clientMods;

        gameOptions.version = dataVersion;

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
