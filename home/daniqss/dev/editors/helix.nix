{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.dev.editors.helix;
in {
  options.dev.editors.helix.enable = mkEnableOption "enable helix editor";

  config = mkIf cfg.enable {
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
        keys = let
          paragraphs = {
            "{" = "goto_prev_paragraph";
            "}" = "goto_next_paragraph";
          };

          moveLines = {
            "A-up" = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
            "A-down" = ["extend_to_line_bounds" "delete_selection" "paste_after"];
          };

          common = paragraphs // moveLines;
        in {
          normal = common;
          select = common;
        };
      };
      themes = {
        autumn_night_transparent = {
          "inherits" = "autumn_night";
          "ui.background" = {};
        };
      };
      languages = {
        language-server.nixd = {
          command = "${pkgs.nixd}/bin/nixd";
        };
        language = [
          {
            name = "nix";
            auto-format = true;
            language-servers = ["nixd"];
            formatter = {
              command = "${pkgs.alejandra}/bin/alejandra";
            };
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
