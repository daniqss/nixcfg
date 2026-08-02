{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  # TODO: fetchAria2c.nix doesn't use `--enable-http-keep-alive=false`
  # so some downloads fail with 421 error (Misdirected Request)
  mkAssetsDir = {
    versionData,
    hash,
  }: let
    inherit (inputs.nixcraft.lib) aria2c manifest;

    assetType = versionData.assets;
    assetIndexFile = pkgs.fetchurl {inherit (versionData.assetIndex) url sha1;};
    inherit ((builtins.fromJSON (builtins.readFile assetIndexFile))) objects;

    entries =
      [
        {
          urls = [versionData.assetIndex.url];
          out = "${assetType}.json";
          dir = "./indexes";
        }
      ]
      ++ lib.mapAttrsToList (_: asset: let
        path = manifest.mkAssetHashPath asset.hash;
      in {
        urls = ["https://resources.download.minecraft.net/${path}"];
        out = baseNameOf path;
        dir = "./objects/${dirOf path}";
      })
      objects;

    inputFile = builtins.toFile "minecraft-asset-dir-inputfile" (aria2c.mkInputEntries entries);
  in
    pkgs.runCommand "minecraft-asset-dir-aria" {
      nativeBuildInputs = [pkgs.aria2];
      outputHashMode = "recursive";
      outputHash = hash;
    } ''
      mkdir -p $out
      cd $out
      aria2c \
        --input-file ${inputFile} \
        --max-concurrent-downloads=5 \
        --enable-http-keep-alive=false \
        --human-readable=true
    '';
in {
  imports = [inputs.nixcraft.homeModules.default];

  options.graphical.gaming.minecraft.mcgf.enable = lib.mkEnableOption "enable declarative minecraft client for mc-gf";

  config = lib.mkIf (config.graphical.enable
    && config.graphical.gaming.enable
    && config.graphical.gaming.minecraft.mcgf.enable) {
    nixcraft = {
      enable = true;

      client = {
        shared = {
          files."screenshots".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Pictures/screenshots";

          # username and uuid are only used by offline instances, online ones
          # take them from the microsoft profile fetched at launch
          account = {
            username = "ranicocs";
            uuid = "adce2a00-a1de-4904-a8d6-4474668a0a15";
            offline = false;
          };

          gameOptions = {
            fullscreen = true;
            guiScale = 2;

            # Modern Minecraft uses graphicsMode: 0 = Fast, 1 = Fancy, 2 = Fabulous.
            graphicsMode = 1;
          };
        };

        instances.mcgf = {
          enable = true;

          version = "1.21.10";
          fabricLoader = {
            enable = true;
            version = "0.18.1";
          };

          mods = {
            fabric-api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/tV4Gc0Zo/fabric-api-0.138.4%2B1.21.10.jar";
              hash = "sha512-XmTFM5Hf0cBZd31nHFK+F6TieinZvXNA6p4/Vc56dws42woV4JZumB7owbk3L7iVQ6J4UhYkaJJorOu4W9XG6Q==";
            };
            sodium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/AANobbMI/versions/sFfidWgd/sodium-fabric-0.7.3%2Bmc1.21.10.jar";
              hash = "sha512-HMzcddly9cF2pIjcyEzOcyC2CKLRBUEvKEckWv+/WqIrGZXto5ITJFP6bhqRVKyZqHrK+NeYm58aI6wQWak9rw==";
            };
            lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/NsswKiwi/lithium-fabric-0.20.1%2Bmc1.21.10.jar";
              hash = "sha512-ebKJLRI/O7EmSZJ92PzMJclV/zihnzq6fNAYDEz1UGwqdtSUGLEwUPkLunu1nzYjrwboonXiroxjgICEBDkCuw==";
            };
          };

          # the file must be writable, nixcraft rotates the token on every launch.
          # to get a refresh token, run:
          # ```sh
          # nix run github:NikoPit/nixcraft#auth
          # mkdir -p ~/.local/share/nixcraft
          # printf '%s\n' '<refreshToken>' > ~/.local/share/nixcraft/microsoft-refresh-token
          # ```
          account.refreshTokenPath = "${config.home.homeDirectory}/.local/share/nixcraft/microsoft-refresh-token";

          # TODO: fix in nixcraft must be done to drop the vanilla asm and keep the loader's one
          # without the workaround, the client crashes
          libraries = lib.mkForce (lib.filter
            (library: !(lib.hasPrefix "org.ow2.asm:" library.name))
            config.nixcraft.client.instances.mcgf.meta.versionData.libraries);

          # the hash covers the whole asset dir, so it has to be recomputed
          # whenever `version` changes
          _classSettings.assetsDir = lib.mkForce (mkAssetsDir {
            versionData = config.nixcraft.client.instances.mcgf.meta.versionData;
            hash = "sha256-J6K1zjWchxoQK1dmHAtxVpM88/8AH6QrEw9wjMA9iuQ=";
          });

          java.memory = 4096;

          binEntry = {
            enable = true;
            name = "mcgf";
          };

          desktopEntry = {
            enable = true;
            name = "Minecraft mc-gf";
          };
        };
      };
    };
  };
}
