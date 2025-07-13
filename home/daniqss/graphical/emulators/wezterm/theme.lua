local wezterm = require("wezterm")

local M = {}

local colors = {
  kinda_onedark = {
    background = "#0A0A0A",
    foreground = "#bdb9ae",
    cursor_color = "#bdb9ae",
    selection_background = "#15171c",
    selection_foreground = "#eeece7",
    ansi = {
      "#15171c", -- black
      "#ec5f67", -- red
      "#80a763", -- green
      "#fdc253", -- yellow
      "#5485c0", -- blue
      "#bf83c0", -- magenta
      "#57c2c0", -- cyan
      "#eeece7", -- white
    },
    brights = {
      "#15171c", -- black
      "#ec5f67", -- red
      "#80a763", -- green
      "#fdc253", -- yellow
      "#5485c0", -- blue
      "#bf83c0", -- magenta
      "#57c2c0", -- cyan
      "#eeece7", -- white
    },
  },
}

local mappings = {
  kinda_onedark = "Kinda OneDark",
}

function M.select(palette, flavor, accent)
  local c = palette[flavor]

  return {
    foreground = c.foreground,
    background = c.background,

    cursor_fg = c.background,
    cursor_bg = c.cursor_color,
    cursor_border = c.cursor_color,

    selection_fg = c.selection_foreground,
    selection_bg = c.selection_background,

    scrollbar_thumb = c.selection_background,

    split = c.ansi[1],

    ansi = c.ansi,
    brights = c.brights,

    indexed = { [16] = c.ansi[2], [17] = c.ansi[3] },

    -- nightbuild only
    compose_cursor = c.ansi[2],

    tab_bar = {
      background = c.background,
      active_tab = {
        bg_color = c.ansi[5],
        fg_color = c.background,
      },
      inactive_tab = {
        bg_color = c.selection_background,
        fg_color = c.foreground,
      },
      inactive_tab_hover = {
        bg_color = c.ansi[1],
        fg_color = c.foreground,
      },
      new_tab = {
        bg_color = c.selection_background,
        fg_color = c.foreground,
      },
      new_tab_hover = {
        bg_color = c.ansi[1],
        fg_color = c.foreground,
      },
      -- fancy tab bar
      inactive_tab_edge = c.selection_background,
    },

    visual_bell = c.selection_background,
  }
end

local function tableMerge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        tableMerge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

function M.apply_to_config(c, opts)
  if not opts then
    opts = {}
  end

  -- default options
  local defaults = {
    flavor = "kinda_onedark",
    accent = "blue",
    color_overrides = {
      kinda_onedark = {},
    },
    token_overrides = {
      kinda_onedark = {},
    },
  }

  local o = tableMerge(defaults, opts)

  -- insert the theme
  local color_schemes = {}
  local palette = tableMerge(colors, o.color_overrides)
  for flavor, name in pairs(mappings) do
    local spec = M.select(palette, flavor, o.accent)
    local overrides = o.token_overrides[flavor]
    color_schemes[name] = tableMerge(spec, overrides)
  end
  if c.color_schemes == nil then
    c.color_schemes = {}
  end
  c.color_schemes = tableMerge(c.color_schemes, color_schemes)

  c.color_scheme = mappings[o.flavor]
  c.command_palette_bg_color = colors[o.flavor].background
  c.command_palette_fg_color = colors[o.flavor].foreground

  local window_frame = {
    active_titlebar_bg = colors[o.flavor].background,
    active_titlebar_fg = colors[o.flavor].foreground,
    inactive_titlebar_bg = colors[o.flavor].background,
    inactive_titlebar_fg = colors[o.flavor].foreground,
    button_fg = colors[o.flavor].foreground,
    button_bg = colors[o.flavor].selection_background,
  }

  if c.window_frame == nil then
    c.window_frame = {}
  end
  c.window_frame = tableMerge(c.window_frame, window_frame)
end

return M