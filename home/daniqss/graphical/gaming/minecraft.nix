{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  isLaptop,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.graphical.gaming.minecraft;

  # nixcraft only prints the microsoft device code to stderr,
  # so the game is opened in a terminal only when the cached session can't be refreshed silently
  launcher = name: let
    instance = config.nixcraft.client.instances.${name};
    auth = lib.getExe inputs.nixcraft.packages.${pkgs.stdenv.hostPlatform.system}.client-auth;
    bin = lib.getExe instance.binEntry.finalBin;
  in
    pkgs.writeShellScript "nixcraft-${name}-launcher" ''
      if ${auth} --auth-dir ${instance.account.authDir} refresh --uuid ${instance.account.uuid} >/dev/null 2>&1; then
        exec ${bin}
      fi
      exec ${lib.getExe config.graphical.emulators.default} -e ${bin}
    '';
in {
  imports = [inputs.nixcraft.homeModules.default];

  options.graphical.gaming.minecraft = {
    enable = mkEnableOption "enable declarative minecraft client";

    lowEnd = mkOption {
      type = types.bool;
      default = isLaptop;
      description = "cheaper graphics defaults, for hosts that can't take the desktop settings";
    };

    shaders = mkOption {
      type = types.bool;
      default = !cfg.lowEnd;
      description = "turn the instance shader pack on in iris, iris stays installed either way";
    };

    memory = mkOption {
      type = types.int;
      default =
        if cfg.lowEnd
        then 4096
        else 8192;
      description = "client heap in MiB";
    };

    options = mkOption {
      type = types.attrsOf types.anything;
      default = {};
      example = {"key_key.hotbar.1" = "key.keyboard.1";};
      description = "host specific options.txt entries, applied over the shared ones";
    };

    extraMods = mkOption {
      type = types.attrsOf types.package;
      default = {};
      description = "host specific client mods, added to every instance";
    };
  };

  config = mkIf cfg.enable {
    nixcraft = {
      enable = true;

      client = {
        shared = {
          files."screenshots".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Pictures/screenshots";

          # username is verified against the authenticated profile,
          # uuid picks which cached account to use.
          # the first launch prints a device code for microsoft.com/link and caches the tokens under ~/.local/share/nixcraft/client/auth,
          # `nixcraft-client-auth login` does the same by hand
          account = {
            username = "ranicocs";
            uuid = "adce2a00-a1de-4904-a8d6-4474668a0a15";
            offline = false;
          };

          optionsTxt =
            {
              fullscreen = false;
              guiScale = 2;
              narrator = null;

              # pov of 100 degrees, calculated to fov with `degrees = 40 * value + 70`
              fov = 0.75;
              gamma = 1.0;

              # values are written verbatim and minecraft wants this one quoted
              graphicsPreset = ''"fancy"'';
              enableVsync = true;

              advancedItemTooltips = true;

              "key_key.hotbar.1" = "key.mouse.5";
              "key_key.hotbar.2" = "key.mouse.4";
              "key_key.hotbar.3" = "key.keyboard.3";
              "key_key.hotbar.4" = "key.keyboard.4";
              "key_key.hotbar.5" = "key.keyboard.r";
              "key_key.hotbar.6" = "key.keyboard.f";
              "key_key.hotbar.7" = "key.keyboard.c";
              "key_key.hotbar.8" = "key.keyboard.x";
              "key_key.hotbar.9" = "key.keyboard.z";

              "key_key.togglePerspective" = "key.keyboard.tab";
              "key_key.swapOffhand" = "key.keyboard.g";

              "key_key.playerlist" = "key.keyboard.f5";
            }
            // lib.optionalAttrs cfg.lowEnd {
              graphicsPreset = ''"fast"'';
              renderDistance = 8;
              simulationDistance = 6;
              entityShadows = false;
              biomeBlendRadius = 0;
              mipmapLevels = 2;
              # decreased
              particles = 1;
            }
            // cfg.options;
        };

        instances =
          outputs.lib.minecraft {inherit pkgs;}
          |> lib.mapAttrs (name: minecraft:
            lib.recursiveUpdate minecraft.client {
              desktopEntry.extraConfig.exec = "${launcher name}";
              java.memory = cfg.memory;
              mods = minecraft.client.mods ++ lib.attrValues cfg.extraMods;
              # merged at launch, so this flips shaders without losing the rest of the iris settings
              files."config/iris.properties".value.enableShaders = cfg.shaders;
            });
      };
    };
  };
}
