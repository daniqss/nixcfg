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
    home.packages = with pkgs; [
      marksman
    ];

    programs.helix = {
      enable = true;
      defaultEditor = true;

      settings = {
        theme = "monokai_pro_spectrum_custom";

        editor = {
          color-modes = true;
          bufferline = "multiple";

          file-picker.hidden = false;

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
          ty = {
            command = "uv";
            args = ["run" "ty" "server"];
          };
          ruff = {
            command = "uv";
            args = ["run" "ruff" "server"];
          };
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
          {
            name = "python";
            auto-format = true;
            language-servers = ["ty" "ruff"];
            formatter = {
              command = "uv";
              args = ["run" "ruff" "format" "-"];
            };
          }

          # TODO: check `rumdl`
          {
            name = "markdown";
            auto-format = true;
            soft-wrap.enable = true;
            language-servers = ["marksman"];
            formatter = {
              command = "${pkgs.mdformat}/bin/mdformat";
              args = ["-"];
            };
          }
        ];
      };
    };
  };
}
