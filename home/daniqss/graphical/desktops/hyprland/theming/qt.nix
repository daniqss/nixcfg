{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.graphical.enable {
    qt = {
      enable = true;
      # platformTheme.name = "gtk";
      # style = {
      #   name = "adwaita-dark";
      #   package = pkgs.adwaita-qt;
      # };
    };
  };
}
