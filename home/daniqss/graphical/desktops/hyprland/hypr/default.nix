{
  hostname,
  username,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.graphical.desktops;
  inherit (config.graphical.emulators) emulator;

  cursor = "Bibata-Modern-Classic-Hyprcursor";
  cursorSize = 24;
  cursorPackage = pkgs.bibata-hyprcursor;

  # touchpad tweaks
  touchpad =
    if hostname == "windrunner"
    then {
      name = "elan071a:00-04f3:30fd-touchpad";
      sensitivity = "0.1";
    }
    else if hostname == "skybreaker"
    then {
      name = "elan0412:01-04f3:3240-touchpad";
      sensitivity = "0.1";
    }
    else null;

  gnomePortal = "${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome";

  # values resolved by nix and exposed as lua globals
  variables = ''
    mod = "SUPER"

    cursorName = "${cursor}"
    cursorSize = "${toString cursorSize}"

    kb_layout = "${cfg.layoutsToDesktopConfig cfg.layouts}"
    emulator = "${emulator}"
    screenshotDir = "/home/${username}/Pictures/screenshots"
    gnomePortal = "${gnomePortal}"

    vicinae_enabled = ${lib.boolToString config.graphical.shells.vicinae.enable}

    ${
      if touchpad != null
      then ''
        touchpad_name = "${touchpad.name}"
        touchpad_sensitivity = ${touchpad.sensitivity}
      ''
      else ""
    }

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

  config = lib.mkIf (cfg.desktop == "hyprland") {
    xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";

    xdg.configFile."hypr/.luarc.json".text = builtins.toJSON {
      workspace.library = ["${pkgs.hyprland}/share/hypr/stubs"];
      diagnostics.globals = ["hl"];
    };

    home.packages = [
      pkgs.hyprshot
      pkgs.wireplumber
      pkgs.playerctl
      pkgs.brightnessctl
    ];

    home.sessionVariables.HYPRSHOT_DIR = "$XDG_SCREENSHOTS_DIR";

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      package = null;
      portalPackage = null;

      configType = "lua";

      # generate a hyprland.lua file requiring the following modules in order
      extraLuaFiles = {
        "00-variables".content = variables;
        "10-monitors".content = cfg.monitorToDesktopConfig cfg.monitors;
        "20-settings".content = ./settings.lua;
        "30-animations".content = ./animations.lua;
        "40-keybinds".content = ./keybinds.lua;
        "50-rules".content = ./rules.lua;
      };
    };
  };
}
