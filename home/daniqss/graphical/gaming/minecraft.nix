{
  inputs,
  outputs,
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

            # the file must be writable, nixcraft rotates the token on every launch.
            # to get a refresh token, run
            # ```sh
            # nix run github:daniqss/nixcraft#auth
            # mkdir -p ~/.local/share/nixcraft
            # printf '%s\n' '<refreshToken>' > ~/.local/share/nixcraft/microsoft-refresh-token
            # ```
            refreshTokenPath = "${config.home.homeDirectory}/.local/share/nixcraft/microsoft-refresh-token";
          };

          gameOptions = {
            fullscreen = false;
            guiScale = 2;
            narrator = null;

            # pov of 100 degrees, calculated to fov with `degrees = 40 * value + 70`
            fov = 0.75;
            gamma = 1.0;

            graphicsMode = 1;

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
          |> lib.mapAttrs (_: minecraft: minecraft.client);
      };
    };
  };
}
