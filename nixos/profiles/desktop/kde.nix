{
  config,
  lib,
  ...
}: {
  options.desktop.kde.enable = lib.mkEnableOption "enable the KDE Plasma 6 desktop";

  config = lib.mkIf config.desktop.kde.enable {
    environment.variables.NIXOS_OZONE_WL = "1";

    services.desktopManager.plasma6.enable = true;
  };
}
