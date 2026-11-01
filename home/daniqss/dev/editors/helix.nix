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
        theme = "monokai_pro_spectrum_custom";

        editor = {
          color-modes = true;
          bufferline = "multiple";

          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
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

      themes.monokai_pro_spectrum_custom = {
        "inherits" = "monokai_pro_spectrum";
        "ui.background" = {};
        "ui.statusline.normal" = {
          fg = "base2";
          bg = "blue";
          modifiers = ["bold"];
        };
        "ui.statusline.insert" = {
          fg = "base2";
          bg = "green";
          modifiers = ["bold"];
        };
        "ui.statusline.select" = {
          fg = "base2";
          bg = "purple";
          modifiers = ["bold"];
        };
        palette = {
          base8 = "#cccccc";
          base2 = "#2a2428";
        };
      };

      languages = {
        language-server = {
          nixd.command = "${pkgs.nixd}/bin/nixd";
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
