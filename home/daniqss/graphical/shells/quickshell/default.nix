{
  hmDir,
  flakeDir,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.graphical.shells.quickshell;
  storeDir = ./. + "/${cfg.configName}";
  liveDir = "${flakeDir}/home/${hmDir}/graphical/shells/quickshell/${cfg.configName}";
in {
  options.graphical.shells.quickshell = {
    enable = lib.mkEnableOption "enable quickshell as shell bar";

    configSource = lib.mkOption {
      type = lib.types.enum ["store" "symlink"];
      default = "store";
    };

    configName = lib.mkOption {
      type = lib.types.str;
      default = "mandra";
    };
  };

  config = lib.mkIf cfg.enable {
    # programs used in quickshell
    home.packages = with pkgs; [
      bottom
      cava
      networkmanager
      libnotify
      kdePackages.qtdeclarative
    ];

    programs.quickshell = {
      enable = true;
      systemd.enable = true;

      package = pkgs.symlinkJoin {
        name = "quickshell-wrapped";
        paths = with pkgs; [
          quickshell

          kdePackages.qtimageformats
          kdePackages.kirigami.unwrapped

          morewaita-icon-theme
          adwaita-icon-theme
          material-symbols
          material-icons
        ];
        meta.mainProgram = pkgs.quickshell.meta.mainProgram;
      };

      activeConfig = cfg.configName;

      configs.${cfg.configName} =
        if cfg.configSource == "store"
        then storeDir
        else config.lib.file.mkOutOfStoreSymlink liveDir;
    };

    systemd.user.services.quickshell = {
      # emoji list for the emoji menu
      Service.Environment = [
        "QS_EMOJI_DATA=${pkgs.unicode-emoji}/share/unicode/emoji/emoji-test.txt"
      ];

      # restart the service if the config changes
      Unit.X-Restart-Triggers = lib.optional (cfg.configSource == "store") "${storeDir}";
    };
  };
}
