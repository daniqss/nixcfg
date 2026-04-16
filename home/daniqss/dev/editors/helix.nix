{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.dev.editors.helix;
in {
  options.dev.editors.helix.enable = lib.mkEnableOption "enable helix editor";

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "autumn_night_transparent";
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
      themes = {
        autumn_night_transparent = {
          "inherits" = "autumn_night";
          "ui.background" = {};
        };
      };
      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
          }
          {
            name = "rust";
            auto-format = true;
          }
        ];
      };
    };
  };
}
