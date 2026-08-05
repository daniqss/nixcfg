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

        instances.ferreiros = {
          enable = true;

          version = "26.2";
          fabricLoader = {
            enable = true;
            version = "0.19.3";
          };

          mods = {
            fabric-api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/3gT0I5vt/fabric-api-0.156.0%2B26.2.jar";
              hash = "sha256-jeGNn2qKKlshIO+ei/+3nMm3WYnAwCLDnJ38G8Oimpk=";
            };
            sodium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/AANobbMI/versions/StFfQ110/sodium-fabric-0.9.2-alpha.3%2Bmc26.2.jar";
              hash = "sha256-TewKWdXJjBYLPAWUpi9wQU5LOAcC9XsDU9o3uckmXFM=";
            };
            lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/f7vZ0VWU/lithium-fabric-0.25.3%2Bmc26.2.jar";
              hash = "sha256-/d6S4jjoB1+JrX9wHyo9WFSviLqaZ2VxhKRAexBKxWM=";
            };
            # incompatible with current sodium version
            # iris = pkgs.fetchurl {
            #   url = "https://cdn.modrinth.com/data/YL57xq9U/versions/oaD6KQls/iris-fabric-1.11.2%2Bmc26.2.jar";
            #   hash = "sha256-3w4szdrqF7GR7aMrIcl54TG8nU70+DERO1C0YfxKOAQ=";
            # };
            modmenu = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/mOgUt4GM/versions/njXb639R/modmenu-20.0.1.jar";
              hash = "sha256-gb+8oGASxXx0lJBy8v+q0GNgut7k0A3Fm/rqyA3SS9g=";
            };
            shulkerboxtooltip = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/2M01OLQq/versions/IHUNStdu/shulkerboxtooltip-fabric-5.4.0%2B26.2.jar";
              hash = "sha256-9cHlcOIlEaQKdi72hkLJrlfsioX8+eownwViKQTto20=";
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
          # with the newer configuration it doesn't matter because minecraft dont crash
          # libraries = lib.mkForce (lib.filter
          #   (library: !(lib.hasPrefix "org.ow2.asm:" library.name))
          #   config.nixcraft.client.instances.ferreiros.meta.versionData.libraries);

          # avoid derivation per asset
          enableFastAssetDownload = true;
          assetHash = "sha256-zfSSmGuvMcKxVnSwMOseqNGC7o52vG9jiDw/8GwELbA=";

          java.memory = 8192;

          binEntry = {
            enable = true;
            name = "ferreiros";
          };

          desktopEntry = {
            enable = true;
            name = "Ferreiros, Minecraft 26.2";

            extraConfig = {
              terminal = false;
              icon = inputs.self + "/assets/icons/ferreiros.png";
            };
          };
        };
      };
    };
  };
}
