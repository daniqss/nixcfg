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

          # shows the hidden files that are tracked by git
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
          clangd.command = "${pkgs.clang-tools}/bin/clangd";
          zls.command = "${pkgs.zls}/bin/zls";
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
            name = "c";
            auto-format = true;
            language-servers = ["clangd"];
            formatter = {
              command = "${pkgs.clang-tools}/bin/clang-format";
            };
          }
          {
            name = "cpp";
            auto-format = true;
            language-servers = ["clangd"];
            formatter = {
              command = "${pkgs.clang-tools}/bin/clang-format";
            };
          }
          {
            name = "zig";
            auto-format = true;
            language-servers = ["zls"];
            formatter = {
              command = "${pkgs.zig}/bin/zig";
              args = ["fmt" "--stdin"];
            };
          }
          {
            name = "python";
            auto-format = true;

            # to use python syntax highlighting with waf, wscript, ...
            file-types = [
              "py"
              "pyi"
              "py3"
              "pyw"
              "ptl"
              "rpy"
              "cpy"
              "ipy"
              "pyt"
              {glob = ".python_history";}
              {glob = ".pythonstartup";}
              {glob = ".pythonrc";}
              {glob = "*SConstruct";}
              {glob = "*SConscript";}
              {glob = "*sconstruct";}
              {glob = "wscript";}
              {glob = "waf";}
            ];
            language-servers = ["ty" "ruff"];
            formatter = {
              command = "uv";
              args = ["run" "ruff" "format" "-"];
            };
          }
        ];
      };
    };
  };
}
