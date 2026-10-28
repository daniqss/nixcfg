{
  username,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.graphical.desktops;

  cursor = "Bibata-Modern-Classic-Hyprcursor";
  cursorSize = 24;
  cursorPackage = pkgs.bibata-hyprcursor;

  gnomePortal = "${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome";

  hyprlandHomeManagerStandaloneWrapper = pkgs.writeShellScriptBin "hyprland-session" ''
    . "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"

    export XDG_CURRENT_DESKTOP="Hyprland"
    export XDG_SESSION_DESKTOP="Hyprland"
    export XDG_SESSION_TYPE="wayland"

    exec "${config.wayland.windowManager.hyprland.finalPackage}/bin/start-hyprland" "$@"
  '';

  # values resolved by nix and exposed as lua globals
  variables = ''
    mod = "SUPER"

    cursorName = "${cursor}"
    cursorSize = "${toString cursorSize}"

    kb_layout = "${cfg.layoutsToDesktopConfig cfg.layouts}"
    kb_variant = "${cfg.variantsToDesktopConfig cfg.layouts}"
    emulator = "${lib.getExe config.graphical.emulators.default}"
    screenshotDir = "/home/${username}/Pictures/screenshots"
    gnomePortal = "${gnomePortal}"

    vicinae_enabled = ${lib.boolToString config.graphical.shells.vicinae.enable}
    work_enabled = ${lib.boolToString config.graphical.misc.work.enable}


    touchpad_sensitivity = ${toString cfg.touchpadSensitivity}

    -- fallback colors, overridden by the matugen-generated colors.lua
    primary = "rgba(8888ffff)"
    secondary = "rgba(8888ffff)"
    tertiary = "rgba(8888ffff)"
    surface_bright = "rgba(444444ff)"
    shadow = "rgba(000000ee)"
    pcall(require, "colors")
  '';
in {
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprsunset.nix
    ./hyprpolkitagent.nix
  ];

  config = lib.mkIf cfg.hyprland.enable {
    xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";

    xdg.configFile."hypr/.luarc.json".text = builtins.toJSON {
      workspace.library = ["${pkgs.hyprland}/share/hypr/stubs"];
      diagnostics.globals = ["hl"];
    };

    home.packages =
      (with pkgs; [
        hyprshot
        # wireplumber
        playerctl
        brightnessctl
        wlrctl
      ])
      ++ lib.optional (!config.platform.isNixOS) hyprlandHomeManagerStandaloneWrapper;

    home.sessionVariables.HYPRSHOT_DIR = "$XDG_SCREENSHOTS_DIR";

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      package =
        if config.platform.isNixOS
        then null
        else pkgs.hyprland;
      portalPackage =
        if config.platform.isNixOS
        then null
        else pkgs.xdg-desktop-portal-hyprland;

      configType = "lua";

      # generate a hyprland.lua file requiring the following modules in order
      extraLuaFiles = {
        "00-variables".content = variables;
        "10-monitors".content = cfg.monitorToDesktopConfig cfg.monitors;
        "20-settings".content = ./settings.lua;
        "30-animations".content = ./animations.lua;
        "40-keybinds".content = ./keybinds.lua;
        "45-jiggler".content = ./jiggler.lua;
        "50-rules".content = ./rules.lua;
      };
    };
  };
}
