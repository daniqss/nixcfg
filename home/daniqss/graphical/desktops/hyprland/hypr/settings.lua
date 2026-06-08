hl.env("HYPRCURSOR_THEME", cursorName)
hl.env("HYPRCURSOR_SIZE", cursorSize)
hl.env("HYPRSHOT_DIR", screenshotDir)
hl.env("NIXOS_OZONE_WL", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor " .. cursorName .. " " .. cursorSize)
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")

  -- nuclear option
  hl.timer(function()
    hl.exec_cmd("kill $(pidof xdg-desktop-portal-gnome)")
  end, { timeout = 2000, type = "oneshot" })

  hl.timer(function()
    hl.exec_cmd(gnomePortal)
  end, { timeout = 3000, type = "oneshot" })
end)

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 6,
    border_size = 2,

    col = {
      active_border = { colors = { primary, secondary, tertiary }, angle = 10 },
      inactive_border = surface_bright,
    },

    layout = "dwindle",
    allow_tearing = true,

    snap = {
      enabled = true,
      window_gap = 15,
      monitor_gap = 25,
      border_overlap = true,
    },
  },

  decoration = {
    rounding = 10,
    rounding_power = 2,

    blur = {
      enabled = false,
      size = 8,
      passes = 2,
      vibrancy = 0.1696,
      brightness = 0.5,
      special = true,
    },

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = shadow,
    },
  },

  input = {
    kb_layout = kb_layout,
    follow_mouse = 1,
    focus_on_close = 1,

    -- -1.0 - 1.0, 0 means no modification.
    sensitivity = -0.6,

    touchpad = {
      natural_scroll = true,
      disable_while_typing = false,
      scroll_factor = 1.4,
    },
  },

  dwindle = {
    force_split = 0,
    special_scale_factor = 0.8,
    split_width_multiplier = 1.0,
    use_active_for_splits = true,
    preserve_split = true,
  },

  master = {
    special_scale_factor = 0.8,
  },

  misc = {
    disable_splash_rendering = true,
    disable_hyprland_logo = true,
    always_follow_on_dnd = false,
    layers_hog_keyboard_focus = true,
    animate_manual_resizes = false,
    enable_swallow = true,
    focus_on_activate = true,
  },
})

if touchpad_name ~= "" then
  hl.device({
    name = touchpad_name,
    sensitivity = touchpad_sensitivity,
  })
end
