# port of loctvl842/monokai-pro.nvim, filter "pro" with a darker background,
# derived colors are the plugin's blends precomputed over this background
{
  "ui.background" = {};
  "ui.text" = "text";
  "ui.text.focus" = {fg = "yellow";};
  "ui.cursor" = {fg = "background"; bg = "dimmed1";};
  "ui.cursor.primary" = {fg = "background"; bg = "text";};
  "ui.cursor.match" = {fg = "yellow"; modifiers = ["bold" "underlined"];};
  "ui.cursorline.primary" = {bg = "cursorline";};
  "ui.linenr" = "dimmed4";
  "ui.linenr.selected" = {fg = "dimmed1"; modifiers = ["bold"];};
  "ui.gutter" = {};
  "ui.selection" = {bg = "selection";};
  "ui.highlight" = {bg = "match";};
  "ui.window" = "dark1";
  "ui.popup" = {fg = "dimmed2"; bg = "dimmed5";};
  "ui.popup.info" = {fg = "dimmed2"; bg = "dimmed5";};
  "ui.help" = {fg = "dimmed2"; bg = "dimmed5";};
  "ui.menu" = {fg = "dimmed2"; bg = "dimmed5";};
  "ui.menu.selected" = {fg = "text"; bg = "dimmed3"; modifiers = ["bold"];};
  "ui.menu.scroll" = {fg = "selection"; bg = "dimmed5";};

  "ui.statusline" = {fg = "dimmed1"; bg = "dark2";};
  "ui.statusline.inactive" = {fg = "dimmed3"; bg = "dark2";};
  "ui.statusline.normal" = {fg = "dark1"; bg = "yellow"; modifiers = ["bold"];};
  "ui.statusline.insert" = {fg = "dark1"; bg = "green"; modifiers = ["bold"];};
  "ui.statusline.select" = {fg = "dark1"; bg = "purple"; modifiers = ["bold"];};
  "ui.bufferline" = {fg = "tab-inactive-fg"; bg = "tab-inactive";};
  "ui.bufferline.active" = {fg = "yellow"; bg = "background";};
  "ui.bufferline.background" = {bg = "dark1";};

  "ui.virtual.whitespace" = "dimmed4";
  "ui.virtual.indent-guide" = "dimmed5";
  "ui.virtual.ruler" = {bg = "dimmed5";};
  "ui.virtual.inlay-hint" = {fg = "dimmed2"; bg = "dimmed5";};
  "ui.virtual.jump-label" = {fg = "yellow"; modifiers = ["bold"];};

  "error" = "red";
  "warning" = "orange";
  "info" = "cyan";
  "hint" = "cyan";
  "diagnostic.error" = {underline = {color = "red"; style = "curl";};};
  "diagnostic.warning" = {underline = {color = "orange"; style = "curl";};};
  "diagnostic.info" = {underline = {color = "cyan"; style = "curl";};};
  "diagnostic.hint" = {underline = {color = "cyan"; style = "curl";};};
  "diagnostic.unnecessary" = {modifiers = ["dim"];};
  "diagnostic.deprecated" = {modifiers = ["crossed_out"];};

  "comment" = {fg = "dimmed3"; modifiers = ["italic"];};

  "attribute" = "green";
  "constructor" = "green";
  "function" = "green";
  "tag" = "red";
  "namespace" = "cyan";
  "label" = "cyan";
  "special" = "orange";

  "type" = "cyan";
  "type.builtin" = {fg = "cyan"; modifiers = ["italic"];};

  "constant" = "purple";
  "constant.numeric" = "purple";
  "constant.character" = "yellow";
  "constant.character.escape" = "purple";

  "string" = "yellow";
  "string.special.url" = {fg = "orange"; modifiers = ["underlined"];};

  "variable" = "text";
  "variable.builtin" = {fg = "dimmed1"; modifiers = ["italic"];};
  "variable.parameter" = {fg = "orange"; modifiers = ["italic"];};
  "variable.other.member" = "text";

  "operator" = "red";
  "punctuation" = "dimmed2";
  "punctuation.bracket" = "red";

  "keyword" = {fg = "red"; modifiers = ["italic"];};
  "keyword.control" = "red";
  "keyword.operator" = "red";
  "keyword.directive" = "red";
  "keyword.storage" = "red";
  "keyword.function" = {fg = "cyan"; modifiers = ["italic"];};
  "keyword.storage.type" = {fg = "cyan"; modifiers = ["italic"];};

  "markup.heading" = {fg = "green"; modifiers = ["bold"];};
  "markup.heading.marker" = "dimmed2";
  "markup.bold" = {modifiers = ["bold"];};
  "markup.italic" = {modifiers = ["italic"];};
  "markup.strikethrough" = {modifiers = ["crossed_out"];};
  "markup.link.url" = {fg = "orange"; modifiers = ["underlined"];};
  "markup.link.text" = {fg = "orange"; modifiers = ["underlined"];};
  "markup.list" = "text";
  "markup.quote" = {fg = "text"; bg = "dimmed5";};
  "markup.raw" = "yellow";

  "diff.plus" = "green";
  "diff.minus" = "red";
  "diff.delta" = "yellow";

  palette = {
    dark2 = "#19181a";
    dark1 = "#221f22";
    background = "#2a2428";
    text = "#cccccc";

    red = "#ff6188";
    orange = "#fc9867";
    yellow = "#ffd866";
    green = "#a9dc76";
    cyan = "#78dce8";
    purple = "#ab9df2";

    dimmed1 = "#c1c0c0";
    dimmed2 = "#939293";
    dimmed3 = "#727072";
    dimmed4 = "#5b595c";
    dimmed5 = "#403e41";

    cursorline = "#322c30";
    selection = "#413b3f";
    match = "#423d41";
    tab-inactive = "#393337";
    tab-inactive-fg = "#918f90";
  };
}
