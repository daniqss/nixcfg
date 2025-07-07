{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.graphical.enable {
    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style = {
        name = "kvantum";
      };
    };
  };
}
