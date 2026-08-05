{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [inputs.nixcraft.homeModules.default];

  options.graphical.gaming.minecraft.enable = lib.mkEnableOption "enable declarative minecraft client";

  config = lib.mkIf (config.graphical.enable
    && config.graphical.gaming.enable
    && config.graphical.gaming.minecraft.enable) {
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
            fullscreen = false;
            guiScale = 2;
            pov = 100;

            # Modern Minecraft uses graphicsMode: 0 = Fast, 1 = Fancy, 2 = Fabulous.
            graphicsMode = 1;
          };
        };

        instances.mcgf = {
          enable = true;

          version = "26.2";
          fabricLoader = {
            enable = true;
            version = "0.19.3";
          };

          mods = {
            fabric-api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/3gT0I5vt/fabric-api-0.156.0%2B26.2.jar";
              hash = lib.fakeHash;
            };
            sodium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/AANobbMI/versions/StFfQ110/sodium-fabric-0.9.2-alpha.3%2Bmc26.2.jar";
              hash = lib.fakeHash;
            };
            lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/mOgUt4GM/versions/njXb639R/modmenu-20.0.1.jar?mr_download_reason=standalone";
              hash = lib.fakeHash;
            };
            iris = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/YL57xq9U/versions/oaD6KQls/iris-fabric-1.11.2%2Bmc26.2.jar?mr_download_reason=standalone";
              hash = lib.fakeHash;
            };
            modmenu = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/mOgUt4GM/versions/njXb639R/modmenu-20.0.1.jar";
              hash = lib.fakeHash;
            };
            shulkerboxtooltip = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/2M01OLQq/versions/IHUNStdu/shulkerboxtooltip-fabric-5.4.0%2B26.2.jar";
              hash = lib.fakeHash;
            };
          };

          # the file must be writable, nixcraft rotates the token on every launch.
          # to get a refresh token, run
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

          # avoid derivation per asset
          enableFastAssetDownload = true;
          assetHash = "sha256-J6K1zjWchxoQK1dmHAtxVpM88/8AH6QrEw9wjMA9iuQ=";

          java.memory = 8192;

          binEntry = {
            enable = true;
            name = "mcgf";
          };

          desktopEntry = {
            enable = true;
            name = "Ferreiros, Minecraft 26.2";

            extraConfig = {
              # terminal = true;
              icon = inputs.self + "/assets/icons/ferreiros.png";
            };
          };
        };
      };
    };
  };
}
