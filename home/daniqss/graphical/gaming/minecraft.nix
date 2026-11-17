{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

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

  options.graphical.gaming.minecraft.enable = mkEnableOption "enable declarative minecraft client";

  config = mkIf config.graphical.gaming.minecraft.enable {
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

          optionsTxt = {
            fullscreen = false;
            guiScale = 2;
            narrator = null;

            # pov of 100 degrees, calculated to fov with `degrees = 40 * value + 70`
            fov = 0.75;
            gamma = 1.0;

            graphicsMode = 1;
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
          };
        };

        instances =
          outputs.lib.minecraft {inherit pkgs;}
          |> lib.mapAttrs (name: minecraft:
            lib.recursiveUpdate minecraft.client {
              desktopEntry.extraConfig.exec = "${launcher name}";
            });
      };
    };
  };
}
