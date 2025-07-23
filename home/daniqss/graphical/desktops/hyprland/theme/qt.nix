{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.graphical.enable {
    qt = {
      enable = true;
      style.name = "adwaita-dark";
    };
  };
}
