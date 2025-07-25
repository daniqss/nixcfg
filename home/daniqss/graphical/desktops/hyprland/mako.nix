{
  lib,
  config,
  ...
}: {
  options.graphical.mako.enable = lib.mkEnableOption "enable mako as notification daemon";

  config = lib.mkIf config.graphical.mako.enable {
    services.mako = {
      enable = true;
      settings = {
        font = "FiraCode Nerd Font Ret 10";
        background-color = "#0a0a0a99";
        padding = 10;
        border-size = 2;
        border-color = "#C6A7F7FF";
        margin = 28;
        border-radius = 10;
        max-icon-size = 52;
        default-timeout = 5000;
      };
    };
  };
}
